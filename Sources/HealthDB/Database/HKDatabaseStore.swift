import Foundation
import SQLite
import CoreLocation
import HealthKit
import HealthKitExtensions

typealias ObjectData = (dataId: Int, startDate: Date, endDate: Date, uuid: UUID, device: HKDevice?, metadata: [String : Any])

public final class HKDatabaseStore {

    private let fileUrl: URL

    private let database: Connection

    private let associations = AssociationsTable()

    private let binarySamples = BinarySamplesTable()

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

    private let scoredAssessmentSamples = ScoredAssessmentSamples()

    private let sleepScheduleSamples = SleepScheduleSamples()

    private let unitStrings = UnitStringsTable()

    private let workouts = WorkoutsTable()

    private let workoutActivities = WorkoutActivitiesTable()

    private let workoutEvents = WorkoutEventsTable()

    private let workoutStatistics = WorkoutStatisticsTable()

    /// Enable some debug statements
    public var printDebugOutput = false

    /**
     Open a Health database at the given url.
     - Parameter fileUrl: The url to the sqlite file
     - Parameter readOnly: Indicate if the database should be writable
     */
    public convenience init(fileUrl: URL, readOnly: Bool = true) throws {
        let database = try Connection(fileUrl.path, readonly: readOnly)
        self.init(fileUrl: fileUrl, database: database)
    }

    init(fileUrl: URL, database: Connection) {
        self.fileUrl = fileUrl
        self.database = database
    }

    private func print(_ message: String) {
        guard printDebugOutput else {
            return
        }
        Swift.print(message)
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

    // MARK: Objects

    /**
     Extract common object properties from a row.
     */
    private func objectData(from row: Row) throws -> ObjectData {
        let dataId = row[samples.table[samples.dataId]]
        let startDate = Date(timeIntervalSinceReferenceDate: row[samples.table[samples.startDate]])
        let endDate = Date(timeIntervalSinceReferenceDate: row[samples.table[samples.endDate]])
        let dataProvenance = row[objects.provenance]
        let uuid = UUID(data: row[objects.table[objects.uuid]]!)!
        let device = try dataProvenances.device(for: dataProvenance, in: database)
        var metadata = try metadata(for: dataId)
        metadata[.externalUUID] = uuid.uuidString
        return (dataId, startDate, endDate, uuid, device, metadata)
    }

    // MARK: Category Samples

    /**
     Access category samples in a date interval.
     */
    public func samples(category: HKCategoryTypeIdentifier, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [HKCategorySample] {
        guard let sampleType = category.intValue else {
            throw HKNotSupportedError("Unsupported category type")
        }
        let query = query(rawCategory: sampleType, from: start, to: end)
        return try database.prepare(query).compactMap {
            try sample(from: $0, category: category)
        }
    }

    /**
     Attempt to extract category samples by specifying the sample type manually.
     */
    public func samples(rawCategory: Int, as category: HKCategoryTypeIdentifier, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [HKCategorySample] {
        let query = query(rawCategory: rawCategory, from: start, to: end)
        return try database.prepare(query).compactMap {
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
                    objects.table[objects.uuid],
                    categorySamples.table[categorySamples.value])
            .join(.leftOuter, objects.table,
                  on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(.leftOuter, categorySamples.table,
                  on: samples.table[samples.dataId] == categorySamples.table[categorySamples.dataId])
    }

    private func sample(from row: Row, category: HKCategoryTypeIdentifier) throws -> HKCategorySample? {
        guard let value = row[categorySamples.value] else {
            return nil
        }
        let object = try objectData(from: row)
        return HKCategorySample(
            type: .init(category),
            value: value,
            start: object.startDate,
            end: object.endDate,
            device: object.device,
            metadata: object.metadata)
    }

    /**
     Get category values for a sample type.

     Use this function to parse category samples where the ``HKCategoryType`` is not known.
     - Note: If no quantity exists for the samples (no entry in `quantity_samples`, then the samples are skipped.
     */
    public func categories(_ sampleType: SampleType, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [RawCategory] {
        guard let rawType = sampleType.rawValue else {
            throw HKNotSupportedError("Unsupported category type")
        }
        return try categories(rawType: rawType, from: start, to: end)
    }

    /**
     Get category values for an unknown type.

     Use this function to parse category samples where the ``HKCategoryType`` is not known.
     */
    public func categories(rawType: Int, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [RawCategory] {
        let selection = query(rawCategory: rawType, from: start, to: end)
        return try database.prepare(selection).compactMap { row -> RawCategory? in
            guard let value = row[categorySamples.value] else {
                //print("Category (\(rawType)) sample \(dataId): No value, ignoring")
                return nil
            }
            let object = try objectData(from: row)
            // Note: Filter out external uuid, since it's already contained in the result
            return .init(
                startDate: object.startDate,
                endDate: object.endDate,
                category: value,
                uuid: object.uuid,
                metadata: object.metadata.withoutUUID(),
                device: object.device)
        }
    }

    // MARK: Quantity Samples

    public func samples(quantity: HKQuantityTypeIdentifier, includingSeriesData: Bool = false, from start: Date = .distantPast, to end: Date = .distantFuture, unit: HKUnit? = nil) throws -> [HKQuantitySample] {
        guard let unit = unit ?? quantity.defaultUnit else {
            throw HKNotSupportedError("Unit needed for the given type")
        }
        guard let sampleType = quantity.intValue else {
            throw HKNotSupportedError("Unsupported quantity type")
        }
        guard includingSeriesData else {
            return try samples(quantity: quantity, sampleType: sampleType, from: start, to: end, unit: unit)
        }
        return try samplesIncludingSeries(quantity: quantity, sampleType: sampleType, from: start, to: end, unit: unit)
    }

    private func samples(quantity: HKQuantityTypeIdentifier, sampleType: Int, from start: Date, to end: Date, unit: HKUnit) throws -> [HKQuantitySample] {
        let selection = query(rawQuantity: sampleType, from: start, to: end)
        return try database.prepare(selection).compactMap {
            try sample(from: $0, quantity: quantity, unit: unit)
        }
    }

    public func samples(rawQuantity: Int, as quantity: HKQuantityTypeIdentifier, unit: HKUnit? = nil, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [HKQuantitySample] {
        guard let unit = unit ?? quantity.defaultUnit else {
            throw HKNotSupportedError("Unit needed for the given type")
        }
        let selection = query(rawQuantity: rawQuantity, from: start, to: end)
        return try database.prepare(selection).compactMap {
            try sample(from: $0, quantity: quantity, unit: unit)
        }
    }

    /**
     Get quantity values for a sample type.

     Use this function to parse quantity samples where the ``HKQuantityType`` is not known.
     - Note: If no quantity exists for the samples (no entry in `quantity_samples`, then the samples are skipped.
     */
    public func quantities(_ sampleType: SampleType, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [RawQuantity] {
        guard let rawType = sampleType.rawValue else {
            throw HKNotSupportedError("Unsupported quantity type")
        }
        return try quantities(rawType: rawType, from: start, to: end)
    }

    /**
     Get quantity values for an unknown type.

     Use this function to parse quantity samples where the ``HKQuantityType`` is not known.
     - Note: If no quantity exists for the samples (no entry in `quantity_samples`, then the samples are skipped.
     */
    public func quantities(rawType: Int, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [RawQuantity] {
        let selection = query(rawQuantity: rawType, from: start, to: end)
        return try database.prepare(selection).compactMap { row -> RawQuantity? in
            guard let value = row[quantitySamples.quantity] else {
                //print("\(quantity) sample \(dataId): No value, ignoring")
                return nil
            }
            let object = try objectData(from: row)
            // Note: Filter out external UUID, since it's contained in result
            return .init(
                startDate: object.startDate,
                endDate: object.endDate,
                quantity: value,
                uuid: object.uuid,
                metadata: object.metadata.withoutUUID(),
                device: object.device)
        }
    }

    public func unknownRawSampleTypes() throws -> Set<Int> {
        let query = samples.table.select(samples.dataType.distinct)
        let unknown = try database.prepare(query)
            .map { $0[samples.dataType.distinct] }
        return Set(unknown)
    }

    private func query(rawQuantity: Int, from start: Date, to end: Date) -> Table {
        quantitySampleQuery
            .filter(samples.table[samples.dataType] == rawQuantity &&
                    samples.table[samples.startDate] <= end.timeIntervalSinceReferenceDate &&
                    samples.table[samples.endDate] >= start.timeIntervalSinceReferenceDate)
    }

    private func query(quantitySampleId dataId: Int) -> Table {
        quantitySampleQuery.filter(samples.table[samples.dataId] == dataId)
    }

    private var quantitySampleQuery: Table {
        samples.table
            .select(samples.table[*],
                    objects.table[objects.provenance],
                    objects.table[objects.uuid],
                    quantitySamples.table[*])
            .join(.leftOuter, objects.table,
                  on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(.leftOuter, quantitySamples.table,
                  on: samples.table[samples.dataId] == quantitySamples.table[quantitySamples.dataId])
    }

    private func sample(from row: Row, quantity: HKQuantityTypeIdentifier, unit: HKUnit) throws -> HKQuantitySample? {
        guard let value = row[quantitySamples.quantity] else {
            //print("\(quantity) sample \(dataId): No value, ignoring")
            return nil
        }
        let object = try objectData(from: row)
        return HKQuantitySample(
            type: .init(quantity),
            quantity: HKQuantity(unit: unit, doubleValue: value),
            start: object.startDate,
            end: object.endDate,
            device: object.device,
            metadata: object.metadata)
    }

    // MARK: Quantity series

    /**
     Query quantity series overlapping a date interval.
     */
    public func series(quantity: HKQuantityTypeIdentifier, unit: HKUnit? = nil, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [HKQuantitySeries] {
        guard let unit = unit ?? quantity.defaultUnit else {
            throw HKNotSupportedError("Unit needed for the given type")
        }
        guard let dataType = quantity.intValue else {
            throw HKNotSupportedError("Unsupported quantity type")
        }
        let query = seriesQuery(quantity: dataType, from: start, to: end)
        return try database.prepare(query).compactMap {
            try series(from: $0, quantity: quantity, unit: unit)
        }
    }

    /**
     Query quantity series with a raw data type.
     */
    public func samples(rawQuantity: Int, as quantity: HKQuantityTypeIdentifier, unit: HKUnit? = nil, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [HKQuantitySeries] {
        guard let unit = unit ?? quantity.defaultUnit else {
            throw HKNotSupportedError("Unit needed for the given type")
        }
        let query = seriesQuery(quantity: rawQuantity, from: start, to: end)
        return try database.prepare(query).compactMap {
            try series(from: $0, quantity: quantity, unit: unit)
        }
    }

    private func seriesQuery(quantity: Int, from start: Date, to end: Date) -> Table {
        // Select the data series and check if they are of the correct type
        // and overlap with the date interval
        // Then construct the sample and the series
        quantitySampleSeries.table
            .join(.leftOuter, samples.table,
                  on: quantitySampleSeries.table[quantitySampleSeries.dataId] == samples.table[samples.dataId])
            .filter(samples.table[samples.dataType] == quantity &&
                    samples.table[samples.startDate] <= end.timeIntervalSinceReferenceDate &&
                    samples.table[samples.endDate] >= start.timeIntervalSinceReferenceDate)
            .join(.leftOuter, quantitySamples.table,
                  on: samples.table[samples.dataId] == quantitySamples.table[quantitySamples.dataId])
            .join(.leftOuter, objects.table,
                  on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(.leftOuter, dataProvenances.table,
                  on: objects.table[objects.provenance] == dataProvenances.table[dataProvenances.rowId])
    }

    private func series(from row: Row, quantity: HKQuantityTypeIdentifier, unit: HKUnit) throws -> HKQuantitySeries? {
        let dataId = row[samples.table[samples.dataId]]
        guard let sample = try sample(from: row, quantity: quantity, unit: unit) else {
            print("Series \(dataId) has no quantity for initial series sample")
            return nil
        }
        return .init(
            dataId: dataId,
            sampleCount: row[quantitySampleSeries.count],
            insertionEra: row[quantitySampleSeries.insertionEra],
            hfdKey: row[quantitySampleSeries.hfdKey],
            seriesLocation: row[quantitySampleSeries.seriesLocation],
            sample: sample,
            identifier: quantity,
            unit: unit)
    }

    /**
     Get the quantities associated with a quantity series.

     The returned samples all have the same data type as the original series sample, and include the same `device` and `metadata`.
     */
    public func quantities(in series: QuantitySeriesProtocol) throws -> [HKQuantitySample] {
        try quantities(for: series.hfdKey, identifier: series.identifier, unit: series.unit)
    }

    private func quantities(for seriesId: Int, identifier: HKQuantityTypeIdentifier, unit: HKUnit? = nil) throws -> [HKQuantitySample] {
        guard let unit = unit ?? identifier.defaultUnit else {
            throw HKNotSupportedError("Unit needed for the given type")
        }
        return try quantitySeriesData.quantities(for: seriesId, in: database, identifier: identifier, unit: unit)
    }

    private func samplesIncludingSeries(quantity: HKQuantityTypeIdentifier, sampleType: Int, from start: Date, to end: Date, unit: HKUnit) throws -> [HKQuantitySample] {
        // First, select all relevant samples
        let query = query(rawQuantity: sampleType, from: start, to: end)

        return try database.prepare(query).mapAndJoin { (row: Row) -> [HKQuantitySample] in
            let dataId = row[samples.table[samples.dataId]]
            guard let sample = try sample(from: row, quantity: quantity, unit: unit) else {
                return []
            }

            // Either select just the sample, or replace it with the samples of the series
            guard let series = try quantitySampleSeries.select(dataId: dataId, in: database) else {
                return [sample]
            }

            // Add device and metadata of the original sample to all series entries
            return try quantitySeriesData
                .quantities(for: series.hfdKey, in: database)
                .filter { $0.start <= end && $0.end >= start }
                .map {
                    HKQuantitySample(
                        type: .init(quantity),
                        quantity: HKQuantity(unit: unit, doubleValue: $0.value),
                        start: $0.start,
                        end: $0.end,
                        device: sample.device,
                        metadata: sample.metadata?.withoutUUID())
                }
        }
    }

    // MARK: Correlations

    public func correlations(_ correlation: HKCorrelationTypeIdentifier, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [HKCorrelation] {
        guard let sampleType = correlation.intValue else {
            throw HKNotSupportedError("Unsupported correlation type")
        }

        let query = correlationQuery(rawType: sampleType, from: start, to: end)

        return try database.prepare(query).compactMap {
            try sample(from: $0, correlation: correlation)
        }
    }

    public func correlations(rawType: Int, as correlation: HKCorrelationTypeIdentifier, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [HKCorrelation] {
        let query = correlationQuery(rawType: rawType, from: start, to: end)
        return try database.prepare(query).compactMap {
            try sample(from: $0, correlation: correlation)
        }
    }

    private func correlationQuery(rawType: Int, from start: Date, to end: Date) -> Table {
        samples.table
            .select(samples.table[*],
                    objects.table[objects.provenance],
                    objects.table[objects.uuid])
            .filter(samples.dataType == rawType &&
                    samples.table[samples.startDate] <= end.timeIntervalSinceReferenceDate &&
                    samples.table[samples.endDate] >= start.timeIntervalSinceReferenceDate)
            .join(.leftOuter, objects.table, on: samples.table[samples.dataId] == objects.table[objects.dataId])
    }

    private func sample(from row: Row, correlation: HKCorrelationTypeIdentifier) throws -> HKCorrelation? {
        let object = try objectData(from: row)
        let objects = try correlatedObjects(for: object.dataId)
        guard !objects.isEmpty else {
            print("No associated samples for correlation \(correlation) (\(object.dataId))")
            return nil
        }
        return HKCorrelation(
            type: .init(correlation),
            start: object.startDate,
            end: object.endDate,
            objects: Set(objects),
            device: object.device,
            metadata: object.metadata)
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
            let sampleType = SampleType(rawValue: rawType)
            return try samples(from: ids, type: sampleType) as [HKSample]
        }
    }

    private func samples(associatedWith dataId: Int, quantity: HKQuantityTypeIdentifier, unit: HKUnit?) throws -> [HKQuantitySample] {
        guard let unit = unit ?? quantity.defaultUnit else {
            throw HKNotSupportedError("Unit needed for the given type")
        }
        guard let dataType = quantity.intValue else {
            throw HKNotSupportedError("Unsupported quantity type")
        }

        return try dataIds(associatedWith: dataId, dataType: dataType).mapAndJoin { dataId -> [HKQuantitySample] in
            guard let row = try database.pluck(query(quantitySampleId: dataId)) else {
                return []
            }
            let dataId = row[samples.table[samples.dataId]]
            guard let sample = try sample(from: row, quantity: quantity, unit: unit) else {
                return []
            }

            // Either select just the sample, or replace it with the samples of the series
            guard let series = try quantitySampleSeries.select(dataId: dataId, in: database) else {
                return [sample]
            }

            // Add device and metadata of the original sample to all series entries
            return try quantitySeriesData.quantities(for: series.hfdKey, in: database)
                .map {
                    HKQuantitySample(
                        type: .init(quantity),
                        quantity: HKQuantity(unit: unit, doubleValue: $0.value),
                        start: $0.start,
                        end: $0.end,
                        device: sample.device,
                        metadata: sample.metadata?.withoutUUID())
                }
        }
    }

    private func samples(associatedWith dataId: Int, category: HKCategoryTypeIdentifier) throws -> [HKCategorySample] {
        guard let dataType = category.intValue else {
            throw HKNotSupportedError("Unsupported category type")
        }
        return try dataIds(associatedWith: dataId, dataType: dataType)
            .compactMap { try database.pluck(query(categorySampleId: $0)) }
            .compactMap { try sample(from: $0, category: category) }
    }

    private func dataIds(associatedWith dataId: Int, dataType: Int) throws -> [Int] {
        let query = associations.query(parentId: dataId)
            .join(samples.table, on: associations.childId == samples.dataId)
            .filter(samples.table[samples.dataType] == dataType)
            .select(samples.dataId)

        return try database.prepare(query)
            .map { $0[samples.dataId] }
    }

    /**
     Create samples from data ids.
     */
    private func samples(from dataIds: [Int], type: SampleType) throws -> [HKSample] {
        switch type {
        case .quantity(let quantityType):
            guard let unit = quantityType.defaultUnit else {
                print("Ignoring \(dataIds.count) \(quantityType) samples due to unknown unit")
                return []
            }
            return try samples(fromQuantityIds: dataIds, type: quantityType, unit: unit)
        case .category(let categoryType):
            return try samples(fromCategoryIds: dataIds, type: categoryType)
        default:
            return []
        }
    }

    /**
     Create quantity samples from data ids.
     */
    private func samples(fromQuantityIds dataIds: [Int], type: HKQuantityTypeIdentifier, unit: HKUnit) throws -> [HKQuantitySample] {
        try dataIds.compactMap { dataId in
            try database.pluck(query(quantitySampleId: dataId)).map { row in
                try sample(from: row, quantity: type, unit: unit)
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

    /**
     Get the metadata for an object.
     - Parameter uuid: The unique identifier of the object.
     - Parameter includePrivateMetadata: Specify if private metadata fields should be returned.
     - Note: Don't specify the UUID of any `HKObject` types returned by functions of the database. Use the external UUID instead.
     */
    public func metadata(for uuid: UUID, includePrivateMetadata: Bool) throws -> [String : Any] {
        guard let dataId = try dataId(for: uuid) else {
            return [:]
        }
        return try metadata(for: dataId, includePrivateMetadata: includePrivateMetadata)
    }

    private func dataId(for uuid: UUID) throws -> Int? {
        guard let uuidData = uuid.data else {
            return nil
        }
        let query = objects.table
            .filter(objects.uuid == uuidData)
            .select(objects.dataId)
        return try database.pluck(query).map { $0[objects.dataId] }
    }

    private func metadata(for dataId: Int) throws -> [String : Any] {
        try metadata(for: dataId, includePrivateMetadata: false)
    }

    public func metadata(for dataId: Int, includePrivateMetadata: Bool) throws -> [String : Any] {
        let selection = metadataValues.table
            .select(metadataValues.table[*], metadataKeys.table[metadataKeys.key])
            .filter(metadataValues.objectId == dataId)
            .join(.leftOuter, metadataKeys.table, on: metadataValues.table[metadataValues.keyId] == metadataKeys.table[metadataKeys.rowId])

        return try database.prepare(selection).reduce(into: [:]) { dict, row in
            let key = row[metadataKeys.key]
            guard includePrivateMetadata || !key.hasPrefix("_HKPrivate") else {
                return
            }
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
     Get a list of all workout activity types in the database.
     */
    public func storedWorkoutTypes() throws -> [HKWorkoutActivityType] {
        let query = workoutActivities.table
            .select(workoutActivities.activityType.distinct)
        return try database.prepare(query).compactMap { row in
            let raw = row[workoutActivities.activityType.distinct]
            return HKWorkoutActivityType(rawValue: UInt(raw))
        }
    }

    /**
     Get a list of all workout activity types in the database including their count
     */
    public func workoutTypeFrequencies() throws -> [HKWorkoutActivityType: Int] {
        let query = workoutActivities.table
            .select(workoutActivities.activityType)
        return try database.prepare(query).reduce(into: [:]) { result, row in
            let raw = row[workoutActivities.activityType]
            guard raw >= 0 else {
                print("Found unknown activity type \(raw)")
                return
            }
            guard let type = HKWorkoutActivityType(rawValue: UInt(raw)) else {
                print("Found unknown activity type \(raw)")
                return
            }
            let oldCount = result[type] ?? 0
            result[type] = oldCount + 1
        }
    }

    /**
     All workouts in the database, regardless of type.
     - Parameter start: The start of the date range of interest
     - Parameter end: The end of the date range of interest
     */
    public func workouts(from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [Workout] {
        let startTime = start.timeIntervalSinceReferenceDate
        let endTime = end.timeIntervalSinceReferenceDate

        let query = workouts.table
            .join(.leftOuter, samples.table, 
                  on: workouts.table[workouts.dataId] == samples.table[samples.dataId])
            .join(.leftOuter, objects.table, 
                  on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .filter(samples.table[samples.startDate] <= endTime &&
                    samples.table[samples.endDate] >= startTime)
        return try database.prepare(query).map { row in
            try workout(from: row)
        }
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
            .join(.leftOuter, samples.table, 
                  on: workouts.table[workouts.dataId] == samples.table[samples.dataId])
            .filter(samples.table[samples.startDate] <= endTime &&
                    samples.table[samples.endDate] >= startTime)
            .join(.leftOuter, objects.table, 
                  on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(.leftOuter, workoutActivities.table, 
                  on: workouts.table[workouts.dataId] == workoutActivities.table[workoutActivities.ownerId])
            .filter(workoutActivities.table[workoutActivities.activityType] == typeId &&
                    workoutActivities.table[workoutActivities.isPrimaryActivity] == true)
        return try database.prepare(query).map {
            try workout(from: $0)
        }
    }

    private func workout(from row: Row) throws -> Workout {
        let object = try objectData(from: row)
        let events = try workoutEvents.events(for: object.dataId, in: database)
        let activities = try workoutActivities.activities(for: object.dataId, in: database)
        return .init(
            dataId: object.dataId,
            startDate: object.startDate,
            endDate: object.endDate,
            totalDistance: row[workouts.totalDistance],
            goalType: row[workouts.goalType],
            goal:  row[workouts.goal],
            events: events,
            activities: activities,
            condensed: condenserInfo(from: row),
            uuid: object.uuid,
            metadata: object.metadata.withoutUUID(),
            device: object.device)
    }

    private func condenserInfo(from row: Row) -> Workout.CondenserInfo? {
        guard let date = row[workouts.condenserDate],
           let version = row[workouts.condenserVersion] else {
            return nil
        }
        return .init(version: version, date: Date(timeIntervalSinceReferenceDate: date))
    }

    public func insert(workout: Workout) throws {
        let (goalType, goalValue) = WorkoutGoalType.values(for: workout.goal)
        let rowid = try database.run(workouts.table.insert(
            workouts.totalDistance <- workout.totalDistance,
            workouts.goalType <- goalType,
            workouts.goal <- goalValue)
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

        if let metadata = workout.metadata {
            for (key, value) in metadata {
                try insert(value, for: key, of: dataId)
            }
        }
    }

    /**
     Get all quantity and category samples associated with a workout.
     */
    public func samples(associatedWith workout: Workout, includePrivateMetadata: Bool = false) throws -> [HKSample] {
        try correlatedObjects(for: workout.dataId)
    }

    public func samples(associatedWith workout: Workout, category: HKCategoryTypeIdentifier, includePrivateMetadata: Bool = false) throws -> [HKCategorySample] {
        try samples(associatedWith: workout.dataId, category: category)
    }

    public func samples(associatedWith workout: Workout, quantity: HKQuantityTypeIdentifier, includePrivateMetadata: Bool = false) throws -> [HKQuantitySample] {
        try samples(associatedWith: workout.dataId, quantity: quantity, unit: nil)
    }

    /**
     Get the route associated with a workout.
     - Parameter workout: The workout for which to select the route
     - Returns: The route associated with the workout, if available
     */
    public func route(associatedWith workout: Workout, includePrivateMetadata: Bool = false) throws -> WorkoutRoute? {
        let query = associations.query(parentId: workout.dataId)
            .join(samples.table, on: associations.childId == samples.table[samples.dataId])
            .filter(samples.table[samples.dataType] == SampleType.Other.workoutRoute.rawValue)
            .join(.leftOuter, objects.table, on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(dataSeries.table, on: dataSeries.table[dataSeries.dataId] == samples.table[samples.dataId])

        return try database.pluck(query).map { row in
            let object = try objectData(from: row)
            return WorkoutRoute(
                dataId: object.dataId,
                isFrozen: row[dataSeries.frozen],
                count: row[dataSeries.count],
                insertionEra: row[dataSeries.insertionEra],
                hfdKey: row[dataSeries.hfdKey],
                seriesLocation: row[dataSeries.seriesLocation],
                startDate: object.startDate,
                endDate: object.endDate,
                uuid: .init(data: row[objects.uuid]!)!,
                device: object.device,
                metadata: object.metadata.withoutUUID())
        }
    }

    /**
     Get the workout configuration for a workout.
     - Parameter workout: The workout for which to get the configuration
     - Returns: The workout configuration, if the workout metadata contains it.
     */
    public func configuration(associatedWith workout: Workout) throws -> WorkoutConfiguration? {
        try metadata(for: workout.uuid, includePrivateMetadata: true)
            .value(forPrivateKey: .workoutConfiguration, as: Data.self)
            .map(WorkoutConfiguration.init)
    }

    /**
     Get the heart rate zone configuration and the time spent in the different zones for a workout.
     - Parameter workout: The workout of interest
     - Returns: The heart rate zones of the workout
     */
    public func heartRateZones(associatedWith workout: Workout) throws -> [HeartRateZone] {
        let metadata = try metadata(for: workout.uuid, includePrivateMetadata: true)
        return try HeartRateZone.from(metadata: metadata)
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
        guard let sampleType = type.intValue else {
            throw HKNotSupportedError("Unsupported quantity type for statistics")
        }
        guard let unit = unit ?? type.defaultUnit else {
            throw HKNotSupportedError("Unsupported quantity type for statistics")
        }
        let query = workoutActivities.table
            .filter(workoutActivities.uuid == uuid)
            .join(workoutStatistics.table, on: workoutStatistics.workoutActivityId == workoutActivities.table[workoutActivities.rowId])
            .filter(workoutStatistics.table[workoutStatistics.dataType] == sampleType)
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

        return try database.prepare(query).map { row in
            try createElectrocardiogram(from: row)
        }
    }

    private func createElectrocardiogram(from row: Row) throws -> Electrocardiogram {
        let object = try objectData(from: row)
        let data = try ecgSamples.payload(for: object.dataId, in: database)
        let frequency = (data?.samplingFrequency).map { HKQuantity(unit: .hertz(), doubleValue: $0) }
        let heartRate = row[ecgSamples.averageHeartRate]
            .map { HKQuantity(unit: .count().unitDivided(by: .minute()), doubleValue: $0) }

        return Electrocardiogram(
            dataId: object.dataId,
            symptomsStatus: .init(rawValue: row[ecgSamples.symptomsStatus])!,
            samplingFrequency: frequency,
            numberOfVoltageMeasurements: data?.inner.samples.count ?? 0,
            classification: .init(rawValue: row[ecgSamples.privateClassification])!,
            averageHeartRate: heartRate,
            startDate: object.startDate,
            endDate: object.endDate,
            uuid: object.uuid,
            metadata: object.metadata,
            device: object.device)
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

    // MARK: Questionaires

    public func questionaires<T>(_ type: T.Type = T.self, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [T] where T: Questionaire {
        let query = questionaireQuery(rawType: type.otherSampleType.rawValue, from: start, to: end)
        return try database.prepare(query).compactMap { row in
            try questionaire(from: row)
        }
    }

    private func questionaireQuery(rawType: Int, from start: Date, to end: Date) -> Table {
        samples.table
            .select(samples.table[*],
                    objects.table[objects.provenance],
                    objects.table[objects.uuid],
                    scoredAssessmentSamples.table[*])
            .join(.leftOuter, objects.table,
                  on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(.leftOuter, scoredAssessmentSamples.table,
                  on: samples.table[samples.dataId] == scoredAssessmentSamples.table[scoredAssessmentSamples.dataId])
            .filter(samples.table[samples.dataType] == rawType &&
                    samples.table[samples.startDate] <= end.timeIntervalSinceReferenceDate &&
                    samples.table[samples.endDate] >= start.timeIntervalSinceReferenceDate)
    }

    private func questionaire<T>(from row: Row) throws -> T where T: Questionaire {
        let object = try objectData(from: row)
        let answers = try questionaireAnswers(from: row[scoredAssessmentSamples.answers])
        return T.init(
            score: row[scoredAssessmentSamples.score],
            risk: .init(rawValue: row[scoredAssessmentSamples.risk])!,
            answers: answers,
            startDate: object.startDate,
            endDate: object.endDate,
            uuid: object.uuid,
            metadata: object.metadata.withoutUUID(),
            device: object.device)
    }

    private func questionaireAnswers(from data: Data) throws -> [Int] {
        let decoder = try NSKeyedUnarchiver(forReadingFrom: data)
        decoder.requiresSecureCoding = false
        guard let values = decoder.decodeObject(of: NSArray.self, forKey: NSKeyedArchiveRootObjectKey) as? [Int] else {
            throw HKError(.unknownError)
        }
        return values
    }

    // MARK: Sleep Schedules

    public func sleepSchedules(from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [SleepScheduleSample] {
        let query = samples.table
            .select(samples.table[*],
                    objects.table[objects.provenance],
                    objects.table[objects.uuid],
                    sleepScheduleSamples.table[*])
            .join(.leftOuter, objects.table,
                  on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(.leftOuter, sleepScheduleSamples.table,
                  on: samples.table[samples.dataId] == sleepScheduleSamples.table[sleepScheduleSamples.dataId])
            .filter(samples.table[samples.dataType] == SampleType.Other.sleepSchedule.rawValue &&
                    samples.table[samples.startDate] <= end.timeIntervalSinceReferenceDate &&
                    samples.table[samples.endDate] >= start.timeIntervalSinceReferenceDate)

        return try database.prepare(query).map { row in
            let object = try objectData(from: row)
            let schedule = sleepScheduleSamples.sleepSchedule(from: row)
            return .init(
                sleepSchedule: schedule,
                startDate: object.startDate,
                endDate: object.endDate,
                uuid: object.uuid,
                metadata: object.metadata.withoutUUID(),
                device: object.device)
        }
    }

    // MARK: Heartbeat Series

    /**
     Query for heartbeat series samples within a date interval.
     */
    public func heartBeatSeries(from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [HeartbeatSeries] {
        try binarySamples(type: SampleType.Other.heartbeatSeries.rawValue, from: start, to: end)
    }

    // MARK: Audiograms

    /**
     Query for audiogram samples within a date interval.
     */
    public func audiograms(from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [HKAudiogramSample] {
        try binarySamples(type: SampleType.Other.audiogram.rawValue, from: start, to: end)
    }

    // MARK: Binary samples

    private func binarySamples<T: BinarySample>(type: Int, from start: Date, to end: Date) throws -> [T] {
        let query = samples.table
            .select(samples.table[*],
                    objects.table[objects.provenance],
                    objects.table[objects.uuid],
                    binarySamples.table[binarySamples.payload])
            .join(.leftOuter, objects.table,
                  on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(.leftOuter, binarySamples.table,
                  on: samples.table[samples.dataId] == binarySamples.table[binarySamples.dataId])
            .filter(samples.table[samples.dataType] == type &&
                    samples.table[samples.startDate] <= end.timeIntervalSinceReferenceDate &&
                    samples.table[samples.endDate] >= start.timeIntervalSinceReferenceDate)
        return try database.prepare(query).compactMap { row in
            let object = try objectData(from: row)
            guard let data = try binarySamples.payload(for: object.dataId, in: database) else {
                return nil
            }
            return T.from(object: object, data: data)
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
        // Referenced by dataSeries, ecgSamples, quantitySeriesData, binarySamples
        try samples.create(in: database)
        // Referenced by quantitySamples
        try unitStrings.create(in: database)

        try associations.create(in: database)
        try binarySamples.create(in: database, referencing: samples)
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
        try scoredAssessmentSamples.create(in: database, referencing: samples)
        try workouts.create(in: database)
        try workoutActivities.create(in: database, referencing: workouts)
        try workoutEvents.create(in: database, referencing: workouts)
        try workoutStatistics.create(in: database, referencing: workoutActivities)
    }
}
