import Foundation
import SQLite
import CoreLocation
import HealthKit
import HealthKitExtensions

public final class HKDatabaseStore {

    private let fileUrl: URL

    private let database: Connection

    private let associations = AssociationsTable()

    private let categorySamples = CategorySamplesTable()

    private let dataProvenances = DataProvenancesTable()

    private let dataSeries = DataSeriesTable()

    private let ecgSamples = ECGSamplesTable()

    private let keyValueSecure = KeyValueSecureTable()

    private let locationSeriesData = LocationSeriesDataTable()

    private let metadataKeys = MetadataKeysTable()

    private let metadataValues = MetadataValuesTable()

    private let objects = ObjectsTable()

    private let quantitySamples = QuantitySamplesTable()

    private let quantitySampleSeries = QuantitySampleSeriesTable()

    private let quantitySeriesData = QuantitySeriesDataTable()

    private let samples = SamplesTable()

    private let unitStrings = UnitStringsTable()

    private let workouts = WorkoutsTable()

    private let workoutActivities = WorkoutActivitiesTable()

    private let workoutEvents = WorkoutEventsTable()

    private let workoutStatistics = WorkoutStatisticsTable()

    /**
     Open a Health database at the given url.
     */
    public convenience init(fileUrl: URL) throws {
        let database = try Connection(fileUrl.path)
        self.init(fileUrl: fileUrl, database: database)
    }

    init(fileUrl: URL, database: Connection) {
        self.fileUrl = fileUrl
        self.database = database
    }

    // MARK: Key-Value

    func value<T>(for key: HKCharacteristicTypeIdentifier) throws -> T? where T: Value {
        try value(for: key.databaseKey!)
    }

    func value<T>(for key: String) throws -> T? where T: Value {
        try keyValueSecure.value(for: key, in: database)
    }

    /**
     A list of all key-value pairs.

     Access all entries in the `key_value_secure` table.
     */
    public func keyValuePairs() throws -> [KeyValueEntry] {
        try keyValueSecure.all(in: database)
    }

    // MARK: Category Samples

    /**
     Access category samples in a date interval.
     */
    public func samples(category: HKCategoryTypeIdentifier, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [HKCategorySample] {
        guard let sampleType = category.sampleType else {
            throw HKNotSupportedError("Unsupported category type")
        }
        let query = query(rawCategory: sampleType.rawValue, from: start, to: end)
        return try database.prepare(query).map {
            try sample(from: $0, category: category)
        }
    }

    /**
     Attempt to extract category samples by specifying the sample type manually.
     */
    public func samples(rawType: Int, as category: HKCategoryTypeIdentifier, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [HKCategorySample] {
        let query = query(rawCategory: rawType, from: start, to: end)
        return try database.prepare(query).map {
            try sample(from: $0, category: category)
        }
    }

    private func query(rawCategory: Int, from start: Date, to end: Date) -> Table {
        categorySampleQuery
            .filter(samples.table[samples.dataType] == rawCategory &&
                    samples.table[samples.startDate] <= end.timeIntervalSinceReferenceDate &&
                    samples.table[samples.endDate] >= start.timeIntervalSinceReferenceDate)
    }

    private func query(categorySampleId dataId: Int) -> Table {
        categorySampleQuery
            .filter(samples.table[samples.dataId] == dataId)
    }

    private var categorySampleQuery: Table {
        samples.table
            .select(samples.table[*],
                    objects.table[objects.provenance],
                    categorySamples.table[categorySamples.value])
            .join(.leftOuter, objects.table, on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(.leftOuter, categorySamples.table, on: samples.table[samples.dataId] == categorySamples.table[categorySamples.dataId])
    }

    private func sample(from row: Row, category: HKCategoryTypeIdentifier) throws -> HKCategorySample {
        let dataId = row[samples.table[samples.dataId]]
        let startDate = Date(timeIntervalSinceReferenceDate: row[samples.startDate])
        let endDate = Date(timeIntervalSinceReferenceDate: row[samples.endDate])
        let dataProvenance = row[objects.provenance]
        let value = row [categorySamples.value]
        let device: HKDevice? = try dataProvenances.device(for: dataProvenance, in: database)
        let metadata = try metadata(for: dataId)
        return HKCategorySample(
            type: .init(category),
            value: value,
            start: startDate,
            end: endDate,
            device: device,
            metadata: metadata)
    }

    // MARK: Quantity Samples

    public func quantitySamples<T>(ofType type: T.Type = T.self) throws -> [T] where T: HKQuantitySampleContainer {
        let selection = try quantitySampleQuery(type: T.quantityTypeIdentifier)

        return try database.prepare(selection)
            .map { try createQuantity(from: $0, type: T.quantityTypeIdentifier, unit: T.defaultUnit) }
            .map { T.init(quantitySample: $0) }
    }

    public func quantitySamples<T>(ofType type: T.Type = T.self, from start: Date, to end: Date) throws -> [T] where T: HKQuantitySampleContainer {
        let selection = try quantitySampleQuery(type: T.quantityTypeIdentifier, from: start, to: end)

        return try database.prepare(selection)
            .map { try createQuantity(from: $0, type: T.quantityTypeIdentifier, unit: T.defaultUnit) }
            .map { T.init(quantitySample: $0) }
    }

    public func quantitySamples(type: HKQuantityTypeIdentifier) throws -> [HKQuantitySample] {
        guard let defaultUnit = type.defaultUnit else {
            throw HKNotSupportedError("Unknown default unit for \(type)")
        }
        let selection = try quantitySampleQuery(type: type)

        return try database.prepare(selection).map { try createQuantity(from: $0, type: type, unit: defaultUnit) }
    }

    public func unknownQuantitySamples(rawDataType: Int, as type: HKQuantityTypeIdentifier, unit: HKUnit? = nil, from start: Date, to end: Date) throws -> [HKQuantitySample] {
        guard let unit = unit ?? type.defaultUnit else {
            throw HKNotSupportedError("Unit needed for the given type")
        }
        let selection = quantitySampleQuery(rawType: rawDataType, from: start, to: end)

        return try database.prepare(selection)
            .map { try createQuantity(from: $0, type: type, unit: unit) }
    }

    private func quantitySampleQuery(type: HKQuantityTypeIdentifier) throws -> Table {
        guard let dataType = type.sampleType?.rawValue else {
            throw HKNotSupportedError("Unsupported category type")
        }
        return quantitySampleQuery(rawType: dataType)
    }

    private func quantitySampleQuery(type: HKQuantityTypeIdentifier, from start: Date, to end: Date) throws -> Table {
        guard let dataType = type.sampleType?.rawValue else {
            throw HKNotSupportedError("Unsupported category type")
        }
        return quantitySampleQuery(rawType: dataType, from: start, to: end)
    }

    private var quantitySampleQuery: Table {
        samples.table
            .select(samples.table[*],
                    objects.table[objects.provenance],
                    quantitySamples.table[*])
            .join(.leftOuter, objects.table, on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(.leftOuter, quantitySamples.table, on: samples.table[samples.dataId] == quantitySamples.table[quantitySamples.dataId])
    }

    private func quantitySampleQuery(dataId: Int) -> Table {
        quantitySampleQuery.filter(samples.table[samples.dataId] == dataId)
    }

    private func quantitySampleQuery(rawType: Int) -> Table {
        quantitySampleQuery.filter(samples.table[samples.dataType] == rawType)
    }

    private func quantitySampleQuery(rawType: Int, from start: Date, to end: Date) -> Table {
        quantitySampleQuery(rawType: rawType)
            .filter(samples.table[samples.startDate] <= end.timeIntervalSinceReferenceDate && samples.table[samples.endDate] >= start.timeIntervalSinceReferenceDate)
    }

    private func createQuantity(from row: Row, type: HKQuantityTypeIdentifier, unit: HKUnit) throws -> HKQuantitySample {
        let dataId = row[samples.table[samples.dataId]]
        let dataProvenance = row[objects.provenance]

        let device: HKDevice? = try dataProvenances.device(for: dataProvenance, in: database)
        let metadata = try metadata(for: dataId)

        let startDate = Date(timeIntervalSinceReferenceDate: row[samples.startDate])
        let endDate = Date(timeIntervalSinceReferenceDate: row[samples.endDate])
        let quantity = row[quantitySamples.quantity]!
        return HKQuantitySample(
            type: .init(type),
            quantity: HKQuantity(unit: unit, doubleValue: quantity),
            start: startDate,
            end: endDate,
            device: device,
            metadata: metadata)
    }

    // MARK: Quantity series

    /**
     Query quantity series overlapping a date interval.
     */
    public func quantitySampleSeries<T>(ofType type: T.Type = T.self, from start: Date, to end: Date) throws -> [TypedQuantitySeries<T>] where T: HKQuantitySampleContainer {
        guard let dataType = type.quantityTypeIdentifier.sampleType else {
            throw HKNotSupportedError("Unsupported quantity type")
        }

        let query = quantitySeriesQuery(dataType: dataType, from: start, to: end)
        return try database.prepare(query)
            .compactMap { row in
                let dataId = row[samples.table[samples.dataId]]
                let sample = try createQuantity(from: row, type: type.quantityTypeIdentifier, unit: T.defaultUnit)
                return .init(
                    dataId: dataId,
                    sampleCount: row[quantitySampleSeries.count],
                    insertionEra: row[quantitySampleSeries.insertionEra],
                    hfdKey: row[quantitySampleSeries.hfdKey],
                    seriesLocation: row[quantitySampleSeries.seriesLocation],
                    sample: T.init(quantitySample: sample))
            }
    }

    /**
     Query quantity series overlapping a date interval.
     */
    public func quantitySampleSeries(type: HKQuantityTypeIdentifier, unit: HKUnit? = nil, from start: Date, to end: Date) throws -> [HKQuantitySeries] {
        guard let unit = unit ?? type.defaultUnit else {
            throw HKNotSupportedError("Unit needed for the given type")
        }
        guard let dataType = type.sampleType else {
            throw HKNotSupportedError("Unsupported quantity type")
        }
        let query = quantitySeriesQuery(dataType: dataType, from: start, to: end)
        return try database.prepare(query).compactMap {
            try createQuantitySeries(from: $0, type: type, unit: unit)
        }
    }

    /**
     Query quantity series with a raw data type.
     */
    public func unknownQuantitySamples(rawDataType: Int, as type: HKQuantityTypeIdentifier, unit: HKUnit? = nil, from start: Date, to end: Date) throws -> [HKQuantitySeries] {
        guard let unit = unit ?? type.defaultUnit else {
            throw HKNotSupportedError("Unit needed for the given type")
        }
        let query = quantitySeriesQuery(rawType: rawDataType, from: start, to: end)
        return try database.prepare(query).compactMap {
            try createQuantitySeries(from: $0, type: type, unit: unit)
        }
    }

    private func createQuantitySeries(from row: Row, type: HKQuantityTypeIdentifier, unit: HKUnit) throws -> HKQuantitySeries {
        let dataId = row[samples.table[samples.dataId]]
        let sample = try createQuantity(from: row, type: type, unit: unit)
        return .init(
            dataId: dataId,
            sampleCount: row[quantitySampleSeries.count],
            insertionEra: row[quantitySampleSeries.insertionEra],
            hfdKey: row[quantitySampleSeries.hfdKey],
            seriesLocation: row[quantitySampleSeries.seriesLocation],
            sample: sample,
            identifier: type,
            unit: unit)
    }

    private func quantitySeriesQuery(dataType: SampleType, from start: Date, to end: Date) -> Table {
        quantitySeriesQuery(rawType: dataType.rawValue, from: start, to: end)
    }

    private func quantitySeriesQuery(rawType: Int, from start: Date, to end: Date) -> Table {
        // Select the data series and check if they are of the correct type
        // and overlap with the date interval
        // Then construct the sample and the series
        quantitySampleSeries.table
            .join(.leftOuter, samples.table, on: quantitySampleSeries.table[quantitySampleSeries.dataId] == samples.table[samples.dataId])
            .filter(samples.table[samples.dataType] == rawType)
            .filter(samples.table[samples.startDate] <= end.timeIntervalSinceReferenceDate
                    && samples.table[samples.endDate] >= start.timeIntervalSinceReferenceDate)
            .join(.leftOuter, quantitySamples.table, on: samples.table[samples.dataId] == quantitySamples.table[quantitySamples.dataId])
            .join(.leftOuter, objects.table, on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(.leftOuter, dataProvenances.table, on: objects.table[objects.provenance] == dataProvenances.table[dataProvenances.rowId])
    }

    /**
     Get the quantities associated with a quantity series.

     The returned samples all have the same data type as the original series sample, and include the same `device` and `metadata`.
     */
    public func quantities<T>(in series: TypedQuantitySeries<T>) throws -> [T] {
        try quantities(in: series)
            .map(T.init(quantitySample:))
    }

    /**
     Get the quantities associated with a quantity series.

     The returned samples all have the same data type as the original series sample, and include the same `device` and `metadata`.
     */
    public func quantities(in series: QuantitySeries) throws -> [HKQuantitySample] {
        try quantities(for: series.hfdKey, identifier: series.identifier, unit: series.unit)
    }

    private func quantities(for seriesId: Int, identifier: HKQuantityTypeIdentifier, unit: HKUnit? = nil) throws -> [HKQuantitySample] {
        guard let unit = unit ?? identifier.defaultUnit else {
            throw HKNotSupportedError("Unit needed for the given type")
        }
        return try quantitySeriesData.quantities(for: seriesId, in: database, identifier: identifier, unit: unit)
    }

    /**
     Count the existing location samples for a location series.
     */
    public func existingSampleCount(for series: QuantitySeries) throws -> Int {
        try database.scalar(quantitySeriesData.table.filter(locationSeriesData.seriesIdentifier == series.hfdKey).count)
    }

    public func quantitySamplesIncludingSeriesData(identifier: HKQuantityTypeIdentifier, unit: HKUnit? = nil, from start: Date, to end: Date) throws -> [HKQuantitySample] {
        guard let unit = unit ?? identifier.defaultUnit else {
            throw HKNotSupportedError("Unit needed for the given type")
        }
        guard let dataType = identifier.sampleType else {
            throw HKNotSupportedError("Unsupported quantity type")
        }
        // First, select all relevant samples
        let query = quantitySampleQuery(rawType: dataType.rawValue, from: start, to: end)

        return try database.prepare(query).mapAndJoin { (row: Row) in
            let dataId = row[samples.table[samples.dataId]]
            let sample = try createQuantity(from: row, type: identifier, unit: unit)

            // Either select just the sample, or replace it with the samples of the series
            guard let series = try quantitySampleSeries.select(dataId: dataId, in: database) else {
                return [sample]
            }
            // Add device and metadata of the original sample to all series entries
            return try quantitySeriesData.quantities(for: series.hfdKey, in: database)
                .filter { $0.start <= end && $0.end >= start }
                .map {
                    .init(
                        type: .init(identifier),
                        quantity: .init(unit: unit, doubleValue: $0.value),
                        start: $0.start,
                        end: $0.end,
                        device: sample.device,
                        metadata: sample.metadata)
                }
        }
    }

    public func quantitySamplesIncludingSeriesData<T>(ofType type: T.Type = T.self, from start: Date, to end: Date) throws -> [T] where T: HKQuantitySampleContainer {
        try quantitySamplesIncludingSeriesData(identifier: type.quantityTypeIdentifier, unit: type.defaultUnit, from: start, to: end)
            .map(T.init(quantitySample:))
    }

    // MARK: Correlations

    func correlationSamples(type: HKCorrelationTypeIdentifier) throws -> [HKCorrelation] {
        guard let sampleType = type.sampleType else {
            throw HKNotSupportedError("Unsupported correlation type")
        }

        let query = samples.table
            .select(samples.table[*],
                    objects.table[objects.provenance])
            .filter(samples.dataType == sampleType.rawValue)
            .join(.leftOuter, objects.table, on: samples.table[samples.dataId] == objects.table[objects.dataId])

        return try database.prepare(query).map { try createCorrelation(from: $0, type: type) }
    }

    private func createCorrelation(from row: Row, type: HKCorrelationTypeIdentifier) throws -> HKCorrelation {
        let dataId = row[samples.table[samples.dataId]]
        let startDate = Date(timeIntervalSinceReferenceDate: row[samples.startDate])
        let endDate = Date(timeIntervalSinceReferenceDate: row[samples.endDate])
        let dataProvenance = row[objects.provenance]
        let device: HKDevice? = try dataProvenances.device(for: dataProvenance, in: database)
        let metadata = try metadata(for: dataId)
        let objects = try correlatedObjects(for: dataId)

        return HKCorrelation(
            type: .init(type),
            start: startDate,
            end: endDate,
            objects: Set(objects),
            device: device,
            metadata: metadata)
    }

    private func correlatedObjects(for dataId: Int) throws -> [HKSample] {
        // Get associated child_id fields from associations where parent_id == data_id
        let query = associations.query(parentId: dataId)
            .join(samples.table, on: associations.childId == samples.dataId)
            .select(samples.dataId, samples.dataType)
        let children: [Int : [Int]] = try database.prepare(query)
            .map { (row: Row) in
                (dataId: row[samples.dataId], dataType: row[samples.dataType])
            }
            .reduce(into: [:]) { dict, element in
                if let existing = dict[element.dataType] {
                    dict[element.dataType] = existing + [element.dataId]
                } else {
                    dict[element.dataType] = [element.dataId]
                }
            }
        guard !children.isEmpty else {
            return []
        }
        return try children.mapAndJoin { (rawType, ids) -> [HKSample] in
            guard let sampleType = SampleType(rawValue: rawType) else {
                print("Ignoring \(ids.count) unknown samples with raw type \(rawType)")
                return []
            }
            return try createSamples(dataIds: ids, type: sampleType) as [HKSample]
        }
    }

    private func associatedSamples(with dataId: Int, identifier: HKQuantityTypeIdentifier, unit: HKUnit?) throws -> [HKQuantitySample] {
        guard let unit = unit ?? identifier.defaultUnit else {
            throw HKNotSupportedError("Unit needed for the given type")
        }
        guard let dataType = identifier.sampleType else {
            throw HKNotSupportedError("Unsupported quantity type")
        }

        return try dataIds(associatedWith: dataId, dataType: dataType)
            .compactMap { dataId in
                try database.pluck(quantitySampleQuery(dataId: dataId))
            }.map { row in
                try createQuantity(from: row, type: identifier, unit: unit)
            }
    }

    private func associatedSamples(with dataId: Int, identifier: HKCategoryTypeIdentifier) throws -> [HKCategorySample] {
        guard let dataType = identifier.sampleType else {
            throw HKNotSupportedError("Unsupported category type")
        }

        return try dataIds(associatedWith: dataId, dataType: dataType)
            .compactMap { dataId in
                try database.pluck(query(categorySampleId: dataId))
            }.map { row in
                try sample(from: row, category: identifier)
            }
    }

    private func dataIds(associatedWith dataId: Int, dataType: SampleType) throws -> [Int] {
        let query = associations.query(parentId: dataId)
            .join(samples.table, on: associations.childId == samples.dataId)
            .filter(samples.table[samples.dataType] == dataType.rawValue)
            .select(samples.dataId)

        return try database.prepare(query)
            .map { $0[samples.dataId] }
    }

    /**
     Create samples from data ids.
     */
    private func createSamples(dataIds: [Int], type: SampleType) throws -> [HKSample] {
        if let quantityType = HKQuantityTypeIdentifier(sampleType: type) {
            guard let unit = quantityType.defaultUnit else {
                print("Ignoring \(dataIds.count) \(quantityType) samples due to unknown unit")
                return []
            }
            return try createQuantitySamples(dataIds: dataIds, type: quantityType, unit: unit)
        }
        if let categoryType = HKCategoryTypeIdentifier(sampleType: type) {
            return try samples(fromCategoryIds: dataIds, type: categoryType)
        }
        if type == .dataSeries {
            print("Ignoring \(dataIds.count) location series")
        } else if type == .workout {
            print("Ignoring \(dataIds.count) associated workouts")
        } else {
            print("Ignoring \(dataIds.count) samples with unhandled sample type \(type)")
        }
        return []
    }

    /**
     Create quantity samples from data ids.
     */
    private func createQuantitySamples(dataIds: [Int], type: HKQuantityTypeIdentifier, unit: HKUnit) throws -> [HKQuantitySample] {
        try dataIds.compactMap { dataId in
            try database.pluck(quantitySampleQuery(dataId: dataId)).map { row in
                try createQuantity(from: row, type: type, unit: unit)
            }
        }
    }

    private func samples(fromCategoryIds dataIds: [Int], type: HKCategoryTypeIdentifier) throws -> [HKCategorySample] {
        try dataIds.compactMap { dataId in
            let query = query(categorySampleId: dataId)
            return try database.pluck(query).map { row in
                try sample(from: row, category: type)
            }
        }
    }

    // MARK: Metadata

    private func metadata(for dataId: Int) throws -> [String : Any] {
        let selection = metadataValues.table
            .select(metadataValues.table[*], metadataKeys.table[metadataKeys.key])
            .filter(metadataValues.objectId == dataId)
            .join(.leftOuter, metadataKeys.table, on: metadataValues.table[metadataValues.keyId] == metadataKeys.table[metadataKeys.rowId])

        return try database.prepare(selection).reduce(into: [:]) { dict, row in
            let key = row[metadataKeys.key]
            let value = metadataValues.convert(row: row)
            dict[key] = value
        }
    }

    private func insert(_ value: Any, for metadataKey: String, of workoutId: Int) throws {
        let keyId = try hasMetadataKey(metadataKey) ?? insert(metadataKey: metadataKey)
        let insert = metadataValues.insert(value, of: workoutId, for: keyId)
        try database.run(insert)
    }

    private func key(for keyId: Int, in database: Connection) throws -> String {
        try database.pluck(metadataKeys.table.filter(metadataKeys.rowId == keyId)).map { $0[metadataKeys.key] }!
    }

    private func allMetadataKeys() throws -> [Int : String] {
        try database.prepare(metadataKeys.table).reduce(into: [:]) {  dict, row in
            dict[row[metadataKeys.rowId]] = row[metadataKeys.key]
        }
    }

    private func hasMetadataKey(_ key: String) throws -> Int? {
        try database.pluck(metadataKeys.table.filter(metadataKeys.key == key)).map { $0[metadataKeys.rowId] }
    }

    private func insert(metadataKey: String) throws -> Int {
        Int(try database.run(metadataKeys.table.insert(metadataKeys.key <- metadataKey)))
    }

    // MARK: Workouts

    /**
     All workouts in the database, regardless of type.
     - Parameter start: The start of the date range of interest
     - Parameter end: The end of the date range of interest
     */
    public func workouts(from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [Workout] {
        let startTime = start.timeIntervalSinceReferenceDate
        let endTime = end.timeIntervalSinceReferenceDate

        let query = workouts.table
            .join(.leftOuter, samples.table, on: workouts.table[workouts.dataId] == samples.table[samples.dataId])
            .filter(samples.table[samples.startDate] <= endTime && 
                    samples.table[samples.endDate] >= startTime)
        return try database.prepare(query).map(createWorkout)
    }

    /**
     All workouts with the given activity type.
     - Parameter type: The activity type of interest
     - Parameter start: The start of the date range of interest
     - Parameter end: The end of the date range of interest
     */
    public func workouts(type: HKWorkoutActivityType, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [Workout] {
        let startTime = start.timeIntervalSinceReferenceDate
        let endTime = end.timeIntervalSinceReferenceDate
        let typeId = Int(type.rawValue)

        // Select only workouts where the primary activity has the correct type
        let query = workouts.table
            .join(.leftOuter, samples.table, on: workouts.table[workouts.dataId] == samples.table[samples.dataId])
            .filter(samples.table[samples.startDate] <= endTime &&
                    samples.table[samples.endDate] >= startTime)
            .join(.leftOuter, workoutActivities.table, on: workouts.table[workouts.dataId] == workoutActivities.table[workoutActivities.ownerId])
            .filter(workoutActivities.table[workoutActivities.activityType] == typeId &&
                    workoutActivities.table[workoutActivities.isPrimaryActivity] == true)
        return try database.prepare(query)
            .map(createWorkout)
    }

    private func createWorkout(from row: Row) throws -> Workout {
        let dataId = row[workouts.table[workouts.dataId]]
        let start = Date(timeIntervalSinceReferenceDate: row[samples.table[samples.startDate]])
        let end = Date(timeIntervalSinceReferenceDate: row[samples.table[samples.endDate]])

        let events = try workoutEvents.events(for: dataId, in: database)
        let activities = try workoutActivities.activities(for: dataId, in: database)
        let metadata = try metadata(for: dataId)
        // TODO: Add workout statistics
        return .init(
            dataId: dataId,
            startDate: start,
            endDate: end,
            totalDistance: row[workouts.totalDistance],
            goalType: row[workouts.goalType],
            goal:  row[workouts.goal],
            events: events,
            activities: activities,
            metadata: metadata)
    }

    public func insert(workout: Workout) throws {
        let rowid = try database.run(workouts.table.insert(
            workouts.totalDistance <- workout.totalDistance,
            workouts.goalType <- workout.goal?.goalType,
            workouts.goal <- workout.goal?.goal)
        )
        let dataId = Int(rowid)
        for event in workout.workoutEvents {
            try workoutEvents.insert(event, dataId: dataId, in: database)
        }

        if let activity = workout.workoutActivities.first {
            try workoutActivities.insert(activity, isPrimaryActivity: true, dataId: dataId, in: database)
        }
        for activity in workout.workoutActivities.dropFirst() {
            try workoutActivities.insert(activity, isPrimaryActivity: false, dataId: dataId, in: database)
        }

        for (key, value) in workout.metadata {
            try insert(value, for: key, of: dataId)
        }
    }

    /**
     Get all quantity and category samples associated with a workout.
     */
    public func samples(associatedWith workout: Workout) throws -> [HKSample] {
        try correlatedObjects(for: workout.dataId)
    }

    public func samples(associatedWith workout: Workout, category: HKCategoryTypeIdentifier) throws -> [HKCategorySample] {
        try associatedSamples(with: workout.dataId, identifier: category)
    }

    public func samples(associatedWith workout: Workout, quantity: HKQuantityTypeIdentifier) throws -> [HKQuantitySample] {
        try associatedSamples(with: workout.dataId, identifier: quantity, unit: nil)
    }

    /**
     Get the route associated with a workout.
     - Parameter workout: The workout for which to select the route
     - Returns: The route associated with the workout, if available
     */
    public func route(associatedWith workout: Workout) throws -> WorkoutRoute? {
        let query = associations.query(parentId: workout.dataId)
            .join(samples.table, on: associations.childId == samples.table[samples.dataId])
            .filter(samples.table[samples.dataType] == SampleType.dataSeries.rawValue)
            .join(.leftOuter, objects.table, on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(dataSeries.table, on: dataSeries.table[dataSeries.dataId] == samples.table[samples.dataId])

        return try database.pluck(query).map { row in
            let dataId = row[samples.table[samples.dataId]]
            let startDate = Date(timeIntervalSinceReferenceDate: row[samples.startDate])
            let endDate = Date(timeIntervalSinceReferenceDate: row[samples.endDate])
            let dataProvenance = row[objects.provenance]
            let device = try dataProvenances.device(for: dataProvenance, in: database)
            let metadata = try metadata(for: dataId)
            return WorkoutRoute(
                dataId: dataId,
                isFrozen: row[dataSeries.frozen],
                count: row[dataSeries.count],
                insertionEra: row[dataSeries.insertionEra],
                hfdKey: row[dataSeries.hfdKey],
                seriesLocation: row[dataSeries.seriesLocation],
                startDate: startDate,
                endDate: endDate,
                uuid: .init(data: row[objects.uuid]!)!,
                device: device,
                metadata: metadata)
        }
    }

    /**
     Get the locations associated with a workout route.
     - Parameter route: The route for which locations are requested
     - Returns: The locations contained in the route
     */
    public func locations(associatedWith route: WorkoutRoute) throws -> [CLLocation] {
        try locationSeriesData.locations(for: route.hfdKey, in: database)
    }

    /**
     Get locations from workout routes.
     */
    public func locations(from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [CLLocation] {
        try locationSeriesData.locations(from: start, to: end, in: database)
    }

    // MARK: Workout statistics

    /**
     Get the statistics associated with a workout activity.
     - Parameter workoutActivity: The activity of interest
     - Returns: A dictionary with the available statistics for the quantity keys
     */
    public func statistics(associatedWith workoutActivity: HKWorkoutActivity) throws -> [HKQuantityType : Statistics] {
        guard let uuid = workoutActivity.externalUUID?.data else {
            throw HKNotSupportedError("No external UUID for workout activity")
        }
        let query = workoutActivities.table
            .filter(workoutActivities.uuid == uuid)
            .join(.leftOuter, workoutStatistics.table, on: workoutStatistics.workoutActivityId == workoutActivities.table[workoutActivities.rowId])

        return try database.prepare(query).reduce(into: [:]) { dict, row in
            guard let statistics = try? workoutStatistics.createStatistics(from: row) else {
                return
            }
            dict[statistics.quantityType] = statistics
        }
    }

    /**
     Get statistics associated with a workout activity.
     - Parameter type: The quantity type of interest
     - Parameter workoutActivity: The activity of interest
     - Returns: The available statistics for the quantity
     */
    public func statistics(_ type: HKQuantityTypeIdentifier, associatedWith workoutActivity: HKWorkoutActivity, unit: HKUnit? = nil) throws -> Statistics? {
        guard let uuid = workoutActivity.externalUUID?.data else {
            throw HKNotSupportedError("No external UUID for workout activity")
        }
        guard let sampleType = type.sampleType else {
            throw HKNotSupportedError("Unsupported quantity type for statistics")
        }
        guard let unit = unit ?? type.defaultUnit else {
            throw HKNotSupportedError("Unsupported quantity type for statistics")
        }
        let query = workoutActivities.table
            .filter(workoutActivities.uuid == uuid)
            .join(workoutStatistics.table, on: workoutStatistics.workoutActivityId == workoutActivities.table[workoutActivities.rowId])
            .filter(workoutStatistics.table[workoutStatistics.dataType] == sampleType.rawValue)
        return try database.pluck(query).map {
            workoutStatistics.createStatistics(from: $0, type: .init(type), unit: unit)
        }
    }

    // MARK: ECG Samples

    /**
     Read Electorcardiogram samples.
     - Parameter start: The start date of the interval to search
     - Parameter end: The end date of the interval to search
     - Returns: The samples in the specified date range
     */
    public func electrocardiograms(from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [Electrocardiogram] {
        let query = ecgSamples.table
            .join(.leftOuter, samples.table, on: ecgSamples.table[ecgSamples.dataId] == samples.table[samples.dataId])
            .join(.leftOuter, objects.table, on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .filter(samples.table[samples.startDate] <= end.timeIntervalSinceReferenceDate &&
                    samples.table[samples.endDate] >= start.timeIntervalSinceReferenceDate)

        return try database.prepare(query).map(createElectrocardiogram)
    }

    private func createElectrocardiogram(from row: Row) throws -> Electrocardiogram {
        let dataId = row[samples.table[samples.dataId]]
        let startDate = Date(timeIntervalSinceReferenceDate: row[samples.startDate])
        let endDate = Date(timeIntervalSinceReferenceDate: row[samples.endDate])
        let dataProvenance = row[objects.provenance]
        let device = try dataProvenances.device(for: dataProvenance, in: database)
        let metadata = try metadata(for: dataId)
        let data = try ecgSamples.payload(for: dataId, in: database)
        let frequency = (data?.samplingFrequency).map { HKQuantity(unit: .hertz(), doubleValue: $0) }
        let heartRate = row[ecgSamples.averageHeartRate]
            .map { HKQuantity(unit: .count().unitDivided(by: .minute()), doubleValue: $0) }

        return Electrocardiogram(
            dataId: dataId,
            symptomsStatus: .init(rawValue: row[ecgSamples.symptomsStatus])!,
            samplingFrequency: frequency,
            numberOfVoltageMeasurements: data?.inner.samples.count ?? 0,
            classification: .init(rawValue: row[ecgSamples.privateClassification])!,
            averageHeartRate: heartRate,
            startDate: startDate,
            endDate: endDate,
            uuid: .init(data: row[objects.uuid]!)!,
            metadata: metadata,
            device: device)
    }

    /**
     Get the voltage measurements associated with an electrocardiogram.
     - Parameter electrocardiogram: The electrocardiogram for which to get voltage measurements
     - Returns: The voltage measurements in the electrocardiogram
     */
    public func voltageMeasurements(associatedWith electrocardiogram: Electrocardiogram) throws -> [HKQuantity] {
        guard let payload = try ecgSamples.payload(for: electrocardiogram.dataId, in: database) else {
            return []
        }
        return payload.inner.samples.map {
            HKQuantity(unit: .voltUnit(with: .micro), doubleValue: Double($0))
        }
    }

    // MARK: Testing

    public convenience init(database: Connection) {
        self.init(fileUrl: .init(filePath: "/"), database: database)
    }

    /**
     Creates all tables.

     Use this function only to create a new database for testing.
     */
    public func createTables() throws {
        // Referenced by dataSeries, ecgSamples, quantitySeriesData
        try samples.create(in: database)
        // Referenced by quantitySamples
        try unitStrings.create(in: database)

        try associations.create(in: database)
        try categorySamples.create(in: database)
        try dataProvenances.create(in: database)
        try dataSeries.create(in: database, referencing: samples)
        try ecgSamples.create(in: database, referencing: samples)
        try keyValueSecure.create(in: database)
        try locationSeriesData.create(in: database, referencing: dataSeries)
        try metadataKeys.create(in: database)
        try metadataValues.create(in: database)
        try objects.create(in: database, referencing: dataProvenances)
        try quantitySamples.create(in: database, referencing: unitStrings)
        try quantitySampleSeries.create(in: database)
        try quantitySeriesData.create(in: database, referencing: samples)
        try workouts.create(in: database)
        try workoutActivities.create(in: database, referencing: workouts)
        try workoutEvents.create(in: database, referencing: workouts)
        try workoutStatistics.create(in: database, referencing: workoutActivities)
    }
}
