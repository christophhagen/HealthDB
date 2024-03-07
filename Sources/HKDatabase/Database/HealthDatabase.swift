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

    public convenience init(fileUrl: URL) throws {
        let database = try Connection(fileUrl.path)
        self.init(fileUrl: fileUrl, database: database)
    }

    init(fileUrl: URL, database: Connection) {
        self.fileUrl = fileUrl
        self.database = database
    }

    // MARK: Key-Value

    func value<T>(for key: String) throws -> T? where T: Value {
        try keyValueSecure.value(for: key, in: database)
    }

    // MARK: Locations

    public func locationSamples(for activity: HKWorkoutActivity) throws -> [CLLocation] {
        try locationSamples(from: activity.startDate, to: activity.currentEndDate)
    }

    private func locationSamples(for seriesId: Int) throws -> [CLLocation] {
        try database.prepare(locationSeriesData.table.filter(locationSeriesData.seriesIdentifier == seriesId)).map(locationSeriesData.location)
    }

    private func locationSampleCount(for seriesId: Int) throws -> Int {
        try database.scalar(locationSeriesData.table.filter(locationSeriesData.seriesIdentifier == seriesId).count)
    }

    public func locationSamples(from start: Date, to end: Date) throws -> [CLLocation] {
        let startTime = start.timeIntervalSinceReferenceDate
        let endTime = end.timeIntervalSinceReferenceDate

        var locations = [CLLocation]()
        for row in try database.prepare(locationSeriesData.table.filter(locationSeriesData.timestamp >= startTime && locationSeriesData.timestamp <= endTime)) {
            locations.append(locationSeriesData.location(row: row))
        }
        return locations
    }

    public func locationSampleCount(from start: Date, to end: Date) throws -> Int {
        let startTime = start.timeIntervalSinceReferenceDate
        let endTime = end.timeIntervalSinceReferenceDate
        return try database.scalar(locationSeriesData.table.filter(locationSeriesData.timestamp >= startTime && locationSeriesData.timestamp <= endTime).count)
    }

    // MARK: Samples

    public func allSamples<T>(ofType type: T.Type = T.self) throws -> [T] where T: HKCategorySampleContainer {
        try categorySamples(type: T.categoryTypeIdentifier)
            .map { T.init(categorySample: $0) }
    }

    func categorySamples(type: HKCategoryTypeIdentifier) throws -> [HKCategorySample] {
        guard let dataType = type.sampleType?.rawValue else {
            throw HKNotSupportedError("Unsupported category type")
        }
        let selection = samples.table
            .select(samples.table[*],
                    objects.table[objects.provenance],
                    categorySamples.table[categorySamples.value])
            .filter(samples.dataType == dataType)
            .join(.leftOuter, objects.table, on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(.leftOuter, categorySamples.table, on: samples.table[samples.dataId] == categorySamples.table[categorySamples.dataId])

        return try database.prepare(selection).map { row in
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
    }

    public func quantitySamples(type: HKQuantityTypeIdentifier) throws -> [HKQuantitySample] {
        guard let dataType = type.sampleType?.rawValue else {
            throw HKNotSupportedError("Unsupported category type")
        }
        let selection = samples.table
            .select(samples.table[*],
                    objects.table[objects.provenance],
                    quantitySamples.table[*])
            .filter(samples.dataType == dataType)
            .join(.leftOuter, objects.table, on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(.leftOuter, quantitySamples.table, on: samples.table[samples.dataId] == quantitySamples.table[quantitySamples.dataId])

        return try database.prepare(selection).map { row in
            let dataId = row[samples.table[samples.dataId]]
            let dataProvenance = row[objects.provenance]
            
            let device: HKDevice? = try dataProvenances.device(for: dataProvenance, in: database)
            let metadata = try metadata(for: dataId)

            let startDate = Date(timeIntervalSinceReferenceDate: row[samples.startDate])
            let endDate = Date(timeIntervalSinceReferenceDate: row[samples.endDate])
            let quantity = row[quantitySamples.quantity]!
            let unit = row[unitStrings.unitString]!
            return HKQuantitySample(
                type: .init(type),
                quantity: HKQuantity(unit: .init(from: unit), doubleValue: quantity),
                start: startDate,
                end: endDate,
                device: device,
                metadata: metadata)
        }
    }

    private func samples(for activityId: Int) throws -> [Sample] {
        /*
        let selection = activities.table
            .select(samples.table[samples.dataId],
                    samples.table[samples.dataType],
                    samples.table[samples.startDate],
                    samples.table[samples.endDate],
                    quantitySamples.table[quantitySamples.quantity])
            .filter(activities.table[activities.ownerId] == activityId)
            .join(.leftOuter, samples.table, on: activities.startDate <= samples.table[samples.startDate] && activities.endDate >= samples.table[samples.endDate])

         SELECT samples.data_type, samples.start_date, samples.end_date,  quantity_series_data.timestamp, quantity_series_data.value, quantity_samples.quantity, quantity_samples.original_quantity, quantity_samples.original_unit
         FROM workout_activities
         LEFT OUTER JOIN samples ON workout_activities.start_date <= samples.start_date AND workout_activities.end_date >= samples.end_date
         LEFT OUTER JOIN quantity_sample_series ON samples.data_id = quantity_sample_series.data_id
         LEFT OUTER JOIN quantity_series_data ON quantity_sample_series.hfd_key = quantity_series_data.series_identifier
         LEFT OUTER JOIN quantity_samples ON samples.data_id = quantity_samples.data_id
         WHERE workout_activities.owner_id = 10794346
         */

        return []
    }

    func samples(from start: Date, to end: Date) throws -> [Sample] {
        let start = start.timeIntervalSinceReferenceDate
        let end = end.timeIntervalSinceReferenceDate

        let selection = samples.table
            .select(samples.table[*],
                    quantitySamples.table[*],
                    dataProvenances.table[dataProvenances.tzName],
                    unitStrings.table[unitStrings.unitString])
            .filter(samples.startDate >= start && samples.endDate <= end)
            .join(.leftOuter, quantitySamples.table, on: samples.table[samples.dataId] == quantitySamples.table[quantitySamples.dataId])
            .join(.leftOuter, objects.table, on: samples.table[samples.dataId] == objects.table[objects.dataId])
            .join(.leftOuter, dataProvenances.table, on: objects.table[objects.provenance] == dataProvenances.table[dataProvenances.rowId])
            .join(.leftOuter, unitStrings.table, on: quantitySamples.table[quantitySamples.originalUnit] == unitStrings.table[unitStrings.rowId])

        return try database.prepare(selection).map { row in
            let id = row[samples.table[samples.dataId]]
            let startDate = Date(timeIntervalSinceReferenceDate: row[samples.startDate])
            let endDate = Date(timeIntervalSinceReferenceDate: row[samples.endDate])
            let dataType = SampleType(rawValue: row[samples.dataType])
            let quantity = row[quantitySamples.quantity]
            let original = row[quantitySamples.originalQuantity]
            let unit = row[unitStrings.unitString]
            let timeZone = row[dataProvenances.tzName].nonEmpty
            return .init(
                id: id,
                startDate: startDate,
                endDate: endDate,
                dataType: dataType,
                quantity: quantity,
                originalQuantity: original,
                originalUnit: unit,
                timeZoneName: timeZone)
        }
    }

    func samples(for activity: HKWorkoutActivity) throws -> [SampleType : [Sample]] {
        try groupedSamples(from: activity.startDate, to: activity.currentEndDate)
    }

    func groupedSamples(from start: Date, to end: Date) throws -> [SampleType : [Sample]] {
        try samples(from: start, to: end).reduce(into: [:]) {
            $0[$1.dataType] = ($0[$1.dataType] ?? []) + [$1]
        }
    }

    func sampleCount(from start: Date, to end: Date) throws -> Int {
        let start = start.timeIntervalSinceReferenceDate
        let end = end.timeIntervalSinceReferenceDate
        return try database.scalar(samples.table.filter(samples.startDate >= start && samples.endDate <= end).count)
    }

    func sampleCount(for activity: HKWorkoutActivity) throws -> Int {
        try sampleCount(from: activity.startDate, to: activity.currentEndDate)
    }

    // MARK: Metadata

    func metadata(for dataId: Int) throws -> [String : Any] {
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

    private func allMetadataKeys() throws -> [Int : Metadata.Key] {
        try database.prepare(metadataKeys.table).reduce(into: [:]) {  dict, row in
            dict[row[metadataKeys.rowId]] = .init(rawValue: row[metadataKeys.key])
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

private extension HKWorkoutActivity {

    var currentEndDate: Date {
        endDate ?? Date()
    }
}
