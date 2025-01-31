import Foundation
import SQLite
import HealthKit

struct WorkoutActivitiesTable {

    let table = Table("workout_activities")

    let rowId = SQLite.Expression<Int>("ROWID")

    let uuid = SQLite.Expression<Data>("uuid")

    let ownerId = SQLite.Expression<Int>("owner_id")

    let isPrimaryActivity = SQLite.Expression<Bool>("is_primary_activity")

    let activityType = SQLite.Expression<Int>("activity_type")

    let locationType = SQLite.Expression<Int>("location_type")

    let swimmingLocationType = SQLite.Expression<Int>("swimming_location_type")

    let lapLength = SQLite.Expression<Data?>("lap_length")

    let startDate = SQLite.Expression<Double>("start_date")

    let endDate = SQLite.Expression<Double>("end_date")

    let duration = SQLite.Expression<Double>("duration")

    let metadata = SQLite.Expression<Data?>("metadata")

    func activities(in database: Connection) throws -> [HKWorkoutActivity] {
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

        var metadata: [String : Any] = try Self.metadata(from: row[self.metadata])
        metadata[HKMetadataKeyExternalUUID] = uuid
        
        // duration: row[columnDuration]
        // isPrimaryActivity: row[columnIsPrimaryActivity]

        return .init(
            workoutConfiguration: configuration,
            start: start,
            end: end,
            metadata: metadata)
    }

    func activities(for workoutId: Int, in database: Connection) throws -> [HKWorkoutActivity] {
        try database.prepare(table.filter(ownerId == workoutId)).map(activity)
    }

    func create(in database: Connection, referencing workouts: WorkoutsTable) throws {
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

    func insert(_ element: HKWorkoutActivity, isPrimaryActivity: Bool, dataId: Int, in database: Connection) throws {
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

private extension WorkoutActivitiesTable {

    static func metadata(from data: Data?) throws -> [String: Any] {
        guard let data else {
            return [:]
        }
        let decoder = try NSKeyedUnarchiver(forReadingFrom: data)
        decoder.requiresSecureCoding = false

        guard let values = decoder.decodeObject(of: NSDictionary.self, forKey: NSKeyedArchiveRootObjectKey) as? [String: Any] else {
            print("Failed to decode workout activity metadata as [String : Any]")
            throw HKError(.unknownError)
        }
        return values
    }
}
