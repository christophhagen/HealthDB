import Foundation
import SQLite
import HealthKit
import HealthKitExtensions
import CoreLocation

struct Tables {

    private let database: Connection

    init(database: Connection) {
        self.database = database
    }

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

    func createTables() throws {
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

    // MARK: Key-Value

    func value<T>(for key: String) throws -> T? where T: Value {
        try keyValueSecure.value(for: key, in: database)
    }

    // MARK: Locations

    func locationSamples(for seriesId: Int, in database: Connection) throws -> [LocationSample] {
        try database.prepare(locationSeriesData.table.filter(locationSeriesData.seriesIdentifier == seriesId)).map(locationSeriesData.location)
    }

    func locationSampleCount(for seriesId: Int, in database: Connection) throws -> Int {
        try database.scalar(locationSeriesData.table.filter(locationSeriesData.seriesIdentifier == seriesId).count)
    }

    func locationSamples(from start: Date, to end: Date, in database: Connection) throws -> [LocationSample] {
        let startTime = start.timeIntervalSinceReferenceDate
        let endTime = end.timeIntervalSinceReferenceDate

        var locations = [CLLocation]()
        for row in try database.prepare(locationSeriesData.table.filter(locationSeriesData.timestamp >= startTime && locationSeriesData.timestamp <= endTime)) {
            locations.append(locationSeriesData.location(row: row))
        }
        return locations
    }

    func locationSampleCount(from start: Date, to end: Date, in database: Connection) throws -> Int {
        let startTime = start.timeIntervalSinceReferenceDate
        let endTime = end.timeIntervalSinceReferenceDate
        return try database.scalar(locationSeriesData.table.filter(locationSeriesData.timestamp >= startTime && locationSeriesData.timestamp <= endTime).count)
    }


    // MARK: Samples

    func categorySamples(type: HKCategoryTypeIdentifier) async throws -> [HKCategorySample] {
        guard let dataType = type.sampleType else {
            throw HKNotSupportedError("Unsupported category type")
        }
        #warning("Implement")
        return []
    }

    func samples(for activityId: Int, from start: Date, to end: Date) throws -> [Sample] {
        let selection = activities.table
            .select(samples.table[samples.dataType],
                    samples.table[samples.startDate],
                    samples.table[samples.endDate],
                    quantitySamples.table[quantitySamples.quantity])
            .filter(activities.table[activities.ownerId] == activityId)
            .join(.leftOuter, samples.table, on: activities.startDate <= samples.table[samples.startDate] && activities.endDate >= samples.table[samples.endDate])

        /*
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

    func sampleCount(from start: Date, to end: Date) throws -> Int {
        let start = start.timeIntervalSinceReferenceDate
        let end = end.timeIntervalSinceReferenceDate
        return try database.scalar(samples.table.filter(samples.startDate >= start && samples.endDate <= end).count)
    }

    func convert(sample: Sample) async throws {
        // Metadata
        // Start, end -> Sample
        // Device?
        // Indentifier: String -> Extensions
        // Value: Int -> Sample
        // Unit -> Extensions
        // UUID -> TODO: Add UUID to sample from objects.uuid
        
    }

    // MARK: Workouts

    func allWorkouts() throws -> [Workout] {
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


    func insert(workout: Workout) throws {
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
}
