import Foundation
import SQLite
import HealthKit

struct WorkoutActivitiesTable {

    private let database: Connection

    private let samples: SamplesTable

    init(database: Connection) {
        self.database = database
        self.samples = .init(database: database)
    }

    let table = Table("workout_activities")

    let rowId = Expression<Int>("ROWID")

    let uuid = Expression<Data>("uuid")

    let ownerId = Expression<Int>("owner_id")

    let isPrimaryActivity = Expression<Bool>("is_primary_activity")

    let activityType = Expression<Int>("activity_type")

    let locationType = Expression<Int>("location_type")

    let swimmingLocationType = Expression<Int>("swimming_location_type")

    let lapLength = Expression<Data?>("lap_length")

    let startDate = Expression<Double>("start_date")

    let endDate = Expression<Double>("end_date")

    let duration = Expression<Double>("duration")

    let metadata = Expression<Data?>("metadata")

    func activities() throws -> [HKWorkoutActivity] {
        try database.prepare(table).map(activity)
    }

    func activity(from row: Row) throws -> HKWorkoutActivity {
        let configuration = HKWorkoutConfiguration()
        configuration.lapLength = try WorkoutActivitiesTable.lapLength(from: row[lapLength])
        configuration.activityType = .init(rawValue: UInt(row[activityType]))!
        configuration.locationType = .init(rawValue: row[locationType])!
        configuration.swimmingLocationType = .init(rawValue: row[swimmingLocationType])!

        let start = Date(timeIntervalSinceReferenceDate: row[startDate])
        let end = Date(timeIntervalSinceReferenceDate: row[endDate])
        let uuid = row[uuid].uuidString

        var metadata: [String : Any] = [ : ]
        metadata[HKMetadataKeyExternalUUID] = uuid
        
        // duration: row[columnDuration]
        // isPrimaryActivity: row[columnIsPrimaryActivity]

        // metadata: row[columnMetadata]
        // TODO: Decode activity metadata
        return .init(
            workoutConfiguration: configuration,
            start: start,
            end: end,
            metadata: metadata)
    }

    func activities(for workoutId: Int) throws -> [HKWorkoutActivity] {
        try database.prepare(table.filter(ownerId == workoutId)).map(activity)
    }

    func samples(for activityId: Int, from start: Date, to end: Date) throws -> [Sample] {
        let selection = table
            .select(samples.table[samples.dataType],
                    samples.table[samples.startDate],
                    samples.table[samples.endDate],
                    samples.quantitySamples.table[samples.quantitySamples.quantity])
            .filter(table[ownerId] == activityId)
            .join(.leftOuter, samples.table, on: startDate <= samples.table[samples.startDate] && endDate >= samples.table[samples.endDate])

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

    private func testQuantity() -> HKQuantitySample {
        let quantity = HKQuantity(unit: .count(), doubleValue: 2)
        let id = HKQuantityTypeIdentifier.flightsClimbed
        return HKQuantitySample(
            type: HKQuantityType(id),
            quantity: quantity,
            start: Date.now,
            end: Date.now,
            device: HKDevice.local(),
            metadata: [String : Any]())
    }

    private func bloodPressure(systolic systolicValue: Double, diastolic diastolicValue: Double) -> HKCorrelation {
        let unit = HKUnit.millimeterOfMercury()

        let systolicQuantity = HKQuantity(unit: unit, doubleValue: systolicValue)
        let diastolicQuantity = HKQuantity(unit: unit, doubleValue: diastolicValue)

        let systolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)!
        let diastolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic)!

        let nowDate = Date()
        let systolicSample = HKQuantitySample(type: systolicType, quantity: systolicQuantity, start: nowDate, end: nowDate)
        let diastolicSample = HKQuantitySample(type: diastolicType, quantity: diastolicQuantity, start: nowDate, end: nowDate)

        let objects: Set<HKSample> = [systolicSample, diastolicSample]
        let type = HKObjectType.correlationType(forIdentifier: .bloodPressure)!
        return HKCorrelation(type: type, start: nowDate, end: nowDate, objects: objects)
    }

    private func testCategory() -> HKCategorySample {
        let id = HKCategoryTypeIdentifier.abdominalCramps
        return HKCategorySample(
            type: HKCategoryType(id),
            value: HKCategoryValueSeverity.moderate.rawValue,
            start: Date.now, 
            end: Date.now,
            device: HKDevice.local(),
            metadata: [String : Any]())
    }

    func create(referencing workouts: WorkoutsTable) throws {
        try database.execute("CREATE TABLE workout_activities (ROWID INTEGER PRIMARY KEY AUTOINCREMENT, uuid BLOB UNIQUE NOT NULL, owner_id INTEGER NOT NULL REFERENCES workouts(data_id) ON DELETE CASCADE, is_primary_activity INTEGER NOT NULL, activity_type INTEGER NOT NULL, location_type INTEGER NOT NULL, swimming_location_type INTEGER NOT NULL, lap_length BLOB, start_date REAL NOT NULL, end_date REAL NOT NULL, duration REAL NOT NULL, metadata BLOB)")
        /*
         try database.run(table.create { t in
            t.column(rowId, primaryKey: .autoincrement)
            t.column(uuid, unique: true)
            t.column(ownerId, references: workouts.table, workouts.dataId) // TODO: ON DELETE CASCADE
            t.column(isPrimaryActivity)
            t.column(activityType)
            t.column(locationType)
            t.column(swimmingLocationType)
            t.column(lapLength)
            t.column(startDate)
            t.column(endDate)
            t.column(duration)
            t.column(metadata)
        })
         */
    }

    func insert(_ element: HKWorkoutActivity, isPrimaryActivity: Bool, dataId: Int) throws {
        try database.run(table.insert(
            uuid <- (element.externalUUID ?? element.uuid).uuidString.data(using: .utf8)!,
            ownerId <- dataId,
            self.isPrimaryActivity <- isPrimaryActivity, // Seems to always be 1
            activityType <- Int(element.workoutConfiguration.activityType.rawValue),
            locationType <- element.workoutConfiguration.locationType.rawValue,
            swimmingLocationType <- element.workoutConfiguration.swimmingLocationType.rawValue,
            lapLength <- try WorkoutActivitiesTable.lapLengthData(lapLength: element.workoutConfiguration.lapLength),
            startDate <- element.startDate.timeIntervalSinceReferenceDate,
            endDate <- element.endDate?.timeIntervalSinceReferenceDate ?? element.startDate.addingTimeInterval(element.duration).timeIntervalSinceReferenceDate,
            duration <- element.duration,
            metadata <- nil)
        )
    }
}

private extension WorkoutActivitiesTable {

    static func lapLengthData(lapLength: HKQuantity?) throws -> Data? {
        try lapLength.map { try NSKeyedArchiver.archivedData(withRootObject: $0, requiringSecureCoding: false) }
    }

    static func lapLength(from data: Data?) throws -> HKQuantity? {
        guard let data else { return nil }
        return try NSKeyedUnarchiver.unarchivedObject(ofClass: HKQuantity.self, from: data)
    }
}
