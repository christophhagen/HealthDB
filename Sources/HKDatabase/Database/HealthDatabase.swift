import Foundation
import SQLite
import CoreLocation
import HealthKit
import HealthKitExtensions

public final class HealthDatabase {

    private let fileUrl: URL

    private let database: Connection

    private let samples = SamplesTable()

    private let categorySamples = CategorySamplesTable()

    private let quantitySamples = QuantitySamplesTable()

    private let quantitySampleSeries = QuantitySampleSeriesTable()
    
    private let quantitySeriesData = QuantitySeriesDataTable()

    private let objects = ObjectsTable()

    private let dataProvenances = DataProvenancesTable()

    private let unitStrings = UnitStringsTable()

    private let workouts = WorkoutsTable()

    private let locationSeriesData = LocationSeriesDataTable()

    private let dataSeries = DataSeriesTable()

    private let keyValueSecure = KeyValueSecureTable()

    private let events = WorkoutEventsTable()

    private let activities = WorkoutActivitiesTable()

    private let metadataValues = MetadataValuesTable()

    private let metadataKeys = MetadataKeysTable()

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
        try keyValueSecure.value(for: key.databaseKey!, in: database)
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

    // MARK: Locations

    public func locations(from start: Date, to end: Date) throws -> [CLLocation] {
        try locationSeriesData.locations(from: start, to: end, in: database)
    }

    /**
     Count the number of location samples in a date interval.
     */
    public func locationSampleCount(from start: Date, to end: Date) throws -> Int {
        try locationSeriesData.locationCount(from: start, to: end, in: database)
    }

    /**
     Query location series overlapping a date interval.
     */
    public func locationSeries(from start: Date, to end: Date) throws -> [LocationSeries] {
        let query = samples.query(type: .dataSeries, from: start, to: end)
        return try database.prepare(query).compactMap { row in
            try dataSeries.select(dataId: row[samples.dataId], in: database)
        }
    }

    /**
     Get the locations associated with a location series.
     */
    public func locations(in series: LocationSeries) throws -> [CLLocation] {
        try locationSeriesData.locations(for: series.hfdKey, in: database)
    }

    /**
     Count the existing location samples for a location series.
     */
    func existingLocationSampleCount(for series: LocationSeries) throws -> Int {
        try database.scalar(locationSeriesData.table.filter(locationSeriesData.seriesIdentifier == series.hfdKey).count)
    }

    // MARK: Category Samples

    /**
     Access category samples in a date interval.
     */
    public func categorySamples<T>(ofType type: T.Type = T.self, from start: Date, to end: Date) throws -> [T] where T: HKCategorySampleContainer {
        try categorySamples(type: T.categoryTypeIdentifier, from: start, to: end)
            .map { T.init(categorySample: $0) }
    }

    /**
     Access category samples in a date interval.
     */
    public func categorySamples(type: HKCategoryTypeIdentifier, from start: Date, to end: Date) throws -> [HKCategorySample] {
        let query = try categorySampleQuery(type: type)
            .filter(samples.table[samples.startDate] <= end.timeIntervalSinceReferenceDate)
            .filter(samples.table[samples.endDate] >= start.timeIntervalSinceReferenceDate)
        return try database.prepare(query).map { try convertRowToCategory(row: $0, type: type) }
    }

    public func categorySamples<T>(ofType type: T.Type = T.self) throws -> [T] where T: HKCategorySampleContainer {
        try categorySamples(type: T.categoryTypeIdentifier)
            .map { T.init(categorySample: $0) }
    }

    /**
     Attempt to extract category samples by specifying the sample type manually.
     */
    public func unknownCategorySamples(rawDataType: Int, as type: HKCategoryTypeIdentifier, from start: Date, to end: Date) throws -> [HKCategorySample] {
        let query = categorySampleQuery(rawDataType: rawDataType)
            .filter(samples.table[samples.startDate] <= end.timeIntervalSinceReferenceDate)
            .filter(samples.table[samples.endDate] >= start.timeIntervalSinceReferenceDate)
        return try database.prepare(query).map { try convertRowToCategory(row: $0, type: type) }
    }

    func categorySamples(type: HKCategoryTypeIdentifier) throws -> [HKCategorySample] {
        let query = try categorySampleQuery(type: type)
        return try database.prepare(query).map { try convertRowToCategory(row: $0, type: type) }
    }

    private func categorySampleQuery(type: HKCategoryTypeIdentifier) throws -> Table {
        guard let dataType = type.sampleType else {
            throw HKNotSupportedError("Unsupported category type")
        }
        return categorySampleQuery(rawDataType: dataType.rawValue)
    }

    private func categorySampleQuery(rawDataType: Int) -> Table {
        samples.table
            .select(samples.table[*],
                    objects.table[objects.provenance],
                    categorySamples.table[categorySamples.value])
            .filter(samples.dataType == rawDataType)
            .join(.leftOuter, objects.table, on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(.leftOuter, categorySamples.table, on: samples.table[samples.dataId] == categorySamples.table[categorySamples.dataId])
    }

    private func convertRowToCategory(row: Row, type: HKCategoryTypeIdentifier) throws -> HKCategorySample {
        let dataId = row[samples.table[samples.dataId]]
        let startDate = Date(timeIntervalSinceReferenceDate: row[samples.startDate])
        let endDate = Date(timeIntervalSinceReferenceDate: row[samples.endDate])
        let dataProvenance = row[objects.provenance]
        let value = row [categorySamples.value]
        let device: HKDevice? = try dataProvenances.device(for: dataProvenance, in: database)
        let metadata = try metadata(for: dataId)
        return HKCategorySample(
            type: .init(type),
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
            .map { try convertRowToQuantity(row: $0, type: T.quantityTypeIdentifier, unit: T.defaultUnit) }
            .map { T.init(quantitySample: $0) }
    }

    public func quantitySamples<T>(ofType type: T.Type = T.self, from start: Date, to end: Date) throws -> [T] where T: HKQuantitySampleContainer {
        let selection = try quantitySampleQuery(type: T.quantityTypeIdentifier, from: start, to: end)

        return try database.prepare(selection)
            .map { try convertRowToQuantity(row: $0, type: T.quantityTypeIdentifier, unit: T.defaultUnit) }
            .map { T.init(quantitySample: $0) }
    }

    public func quantitySamples(type: HKQuantityTypeIdentifier) throws -> [HKQuantitySample] {
        guard let defaultUnit = type.defaultUnit else {
            throw HKNotSupportedError("Unknown default unit for \(type)")
        }
        let selection = try quantitySampleQuery(type: type)

        return try database.prepare(selection).map { try convertRowToQuantity(row: $0, type: type, unit: defaultUnit) }
    }

    public func unknownQuantitySamples(rawDataType: Int, as type: HKQuantityTypeIdentifier, unit: HKUnit? = nil, from start: Date, to end: Date) throws -> [HKQuantitySample] {
        guard let unit = unit ?? type.defaultUnit else {
            throw HKNotSupportedError("Unit needed for the given type")
        }
        let selection = quantitySampleQuery(rawType: rawDataType, from: start, to: end)

        return try database.prepare(selection)
            .map { try convertRowToQuantity(row: $0, type: type, unit: unit) }
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

    private func quantitySampleQuery(rawType: Int) -> Table {
        return samples.table
            .select(samples.table[*],
                    objects.table[objects.provenance],
                    quantitySamples.table[*])
            .filter(samples.dataType == rawType)
            .join(.leftOuter, objects.table, on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(.leftOuter, quantitySamples.table, on: samples.table[samples.dataId] == quantitySamples.table[quantitySamples.dataId])
    }

    private func quantitySampleQuery(rawType: Int, from start: Date, to end: Date) -> Table {
        quantitySampleQuery(rawType: rawType)
            .filter(samples.table[samples.startDate] <= end.timeIntervalSinceReferenceDate && samples.table[samples.endDate] >= start.timeIntervalSinceReferenceDate)
    }

    private func convertRowToQuantity(row: Row, type: HKQuantityTypeIdentifier, unit: HKUnit) throws -> HKQuantitySample {
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
            throw HKNotSupportedError("Unsupported category type")
        }

        let query = quantitySeriesQuery(dataType: dataType, from: start, to: end)
        return try database.prepare(query)
            .compactMap { row in
                let dataId = row[samples.table[samples.dataId]]
                let sample = try convertRowToQuantity(row: row, type: type.quantityTypeIdentifier, unit: T.defaultUnit)
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
            throw HKNotSupportedError("Unsupported category type")
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
        let sample = try convertRowToQuantity(row: row, type: type, unit: unit)
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
            throw HKNotSupportedError("Unsupported category type")
        }
        // First, select all relevant samples
        let query = quantitySampleQuery(rawType: dataType.rawValue, from: start, to: end)

        return try database.prepare(query).reduce(into: []) { (result: inout [HKQuantitySample], row: Row) in
            let dataId = row[samples.table[samples.dataId]]
            let sample = try convertRowToQuantity(row: row, type: identifier, unit: unit)

            // Either select just the sample, or replace it with the samples of the series
            guard let series = try quantitySampleSeries.select(dataId: dataId, in: database) else {
                result += [sample]
                return
            }
            // Add device and metadata of the original sample to all series entries
            result += try quantitySeriesData.quantities(for: series.hfdKey, in: database)
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

    public func readAllWorkouts() throws -> [Workout] {
        return try database.prepare(workouts.table).map { row in
            let id = row[workouts.dataId]

            let events = try events.events(for: id, in: database)
            let activities = try activities.activities(for: id, in: database)
            let metadata = try metadata(for: id)
            return .init(
                id: id,
                totalDistance: row[workouts.totalDistance],
                goalType: row[workouts.goalType],
                goal:  row[workouts.goal],
                condenserVersion: row[workouts.condenserVersion],
                condenserDate: row[workouts.condenserDate].map { Date.init(timeIntervalSinceReferenceDate: $0) },
                events: events,
                activities: activities,
                metadata: metadata)
        }
    }

    public func insert(workout: Workout) throws {
        let rowid = try database.run(workouts.table.insert(
            workouts.totalDistance <- workout.totalDistance,
            workouts.goalType <- workout.goal?.goalType,
            workouts.goal <- workout.goal?.gaol,
            workouts.condenserVersion <- workout.condenserVersion,
            workouts.condenserDate <- workout.condenserDate?.timeIntervalSinceReferenceDate)
        )
        let dataId = Int(rowid)
        for event in workout.events {
            try events.insert(event, dataId: dataId, in: database)
        }

        for activity in workout.activities {
            try activities.insert(activity, isPrimaryActivity: true, dataId: dataId, in: database)
        }

        for (key, value) in workout.metadata {
            try insert(value, for: key, of: dataId)
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
        try samples.create(in: database)
        try unitStrings.create(in: database)
        try quantitySamples.create(referencing: unitStrings, in: database)
        try dataProvenances.create(in: database)
        try objects.create(referencing: dataProvenances, in: database)
        try workouts.create(in: database)
        try events.create(referencing: workouts, in: database)
        try activities.create(referencing: workouts, in: database)
        try metadataValues.create(in: database)
        try metadataKeys.create(in: database)
        try locationSeriesData.create(references: dataSeries, in: database)
    }


    private func testActivityOverlap() throws {
        let workouts = try readAllWorkouts()
        let activities = workouts.map { $0.activities }.joined().sorted()
        var current = activities.first!
        for next in activities.dropFirst() {
            let overlap = next.startDate.timeIntervalSince(current.currentEndDate)
            if overlap < 0 {
                print("Overlap \(-overlap.roundedInt) s:")
                print("    Activity \(current.workoutConfiguration.activityType): \(current.startDate) -> \(current.currentEndDate)")
                print("    Activity \(next.workoutConfiguration.activityType): \(next.startDate) -> \(next.currentEndDate)")
            }
            current = next
        }
    }

    func insert(workout: Workout, into store: HKHealthStore) async throws -> HKWorkout? {
        guard let configuration = workout.activities.first?.workoutConfiguration else {
            return nil
        }

        let builder = HKWorkoutBuilder(healthStore: store, configuration: configuration, device: nil)
        let metadata = workout.metadata.reduce(into: [:]) { dict, element in
            dict[element.key] = element.value
        }
        try await builder.addMetadata(metadata)
        //try await builder.addSamples(<#T##samples: [HKSample]##[HKSample]#>)
        try await builder.addWorkoutEvents(workout.events)
        for activity in workout.activities {
            try await builder.addWorkoutActivity(activity)
        }
        let endDate = workout.activities.compactMap { $0.endDate }.max() ?? Date()
        try await builder.endCollection(at: endDate)
        return try await builder.finishWorkout()
    }
}
