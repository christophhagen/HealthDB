import Foundation
import SQLite
import HealthKit

struct WorkoutEventsTable {

    let table = Table("workout_events")

    // INTEGER PRIMARY KEY AUTOINCREMENT
    let rowId = SQLite.Expression<Int>("ROWID")

    // owner_id INTEGER NOT NULL REFERENCES workouts (data_id) ON DELETE CASCADE
    let ownerId = SQLite.Expression<Int>("owner_id")

    // date REAL NOT NULL
    let date = SQLite.Expression<Double>("date")

    // type INTEGER NOT NULL
    let type = SQLite.Expression<Int>("type")

    // duration REAL NOT NULL
    let duration = SQLite.Expression<Double>("duration")

    // metadata BLOB
    let metadata = SQLite.Expression<Data?>("metadata")

    // session_uuid BLOB
    let sessionUUID = SQLite.Expression<Data?>("session_uuid")

    // error BLOB
    let error = SQLite.Expression<Data?>("error")

    func events(in database: Connection) throws -> [HKWorkoutEvent] {
        try database.prepare(table).map(event)
    }

    func events(for workoutId: Int, in database: Connection) throws -> [HKWorkoutEvent] {
        try database.prepare(table.filter(ownerId == workoutId)).map(event)
    }

    private func event(from row: Row) -> HKWorkoutEvent {
        let start = Date(timeIntervalSinceReferenceDate: row[date])
        let interval = DateInterval(start: start, duration: row[duration])
        let metadata = metadata(row[metadata])
        let type = HKWorkoutEventType(rawValue: row[type])!
        // let sessionUUID = row[sessionUUID]
        // let error = row[error]
        return .init(type: type, dateInterval: interval, metadata: metadata)
    }

    private func metadata(_ data: Data?) -> [String : Any] {
        guard let data else {
            return [:]
        }
        return WorkoutEventsTable.decode(metadata: data)
    }

    func create(in database: Connection, referencing workouts: WorkoutsTable) throws {
        // CREATE TABLE workout_events (ROWID INTEGER PRIMARY KEY AUTOINCREMENT, owner_id INTEGER NOT NULL REFERENCES workouts (data_id) ON DELETE CASCADE, date REAL NOT NULL, type INTEGER NOT NULL, duration REAL NOT NULL, metadata BLOB, session_uuid BLOB, error BLOB)
        try database.run(table.create { t in
            t.column(rowId, primaryKey: .autoincrement)
            t.column(ownerId, references: workouts.table, workouts.dataId)
            t.column(date)
            t.column(type)
            t.column(duration)
            t.column(metadata)
            t.column(sessionUUID)
            t.column(error)
        })
    }

    func insert(_ element: HKWorkoutEvent, dataId: Int, in database: Connection) throws {
        try database.run(table.insert(
            ownerId <- dataId,
            date <- element.dateInterval.start.timeIntervalSinceReferenceDate,
            type <- element.type.rawValue,
            duration <- element.dateInterval.duration,
            metadata <- WorkoutEventsTable.encode(metadata: element.metadata ?? [:]))
            // SessionUUID <- element.sessionUUID
            // Error <- element.error)
        )
    }
}

extension WorkoutEventsTable {

    static func decode(metadata data: Data) -> [String : Any] {
        let metadata: WorkoutEventMetadata
        do {
            metadata = try WorkoutEventMetadata(serializedData: data)
        } catch {
            print("Failed to decode event metadata: \(error)")
            print(data.hex)
            return [:]
        }

        return metadata.elements.reduce(into: [:]) { dict, element in
            guard let value = element.value else {
                print("No value for metadata element \(element)")
                print(data.hex)
                return
            }
            dict[element.key] = value
        }
    }

    static func encode(metadata: [String : Any]) -> Data? {
        let wrapper = WorkoutEventMetadata.with {
            $0.elements = metadata.compactMap { .from(key: $0.key, value: $0.value) }
        }
        guard !wrapper.elements.isEmpty else {
            return nil
        }
        do {
            return try wrapper.serializedData()
        } catch {
            print("Failed to encode event metadata: \(error)")
            return nil
        }
    }
}

private extension WorkoutEventMetadata.Element {

    var value: Any? {
        if hasUnsignedValue {
            return unsignedValue
        }
        if hasQuantity {
            return HKQuantity(unit: .init(from: quantity.unit), doubleValue: quantity.value)
        }
        return UInt(0)
    }

    static func from(key: String, value: Any) -> Self? {
        if let value = value as? UInt64 {
            return .with {
                $0.key = key
                $0.unsignedValue = UInt64(value)
            }
        }
        guard let value = value as? HKQuantity else {
            print("Unknown value type \(type(of: value)) for metadata key \(key): \(value)")
            return nil
        }

        let number: Double
        let unit: String
        if value.is(compatibleWith: .meter()) {
            number = value.doubleValue(for: .meter())
            unit = "m"
        } else if value.is(compatibleWith: .second()) {
            number = value.doubleValue(for: .second())
            unit = "s"
        } else {
            print("Unhandled quantity type for metadata key \(key): \(value)")
            return nil
        }

        return .with { el in
            el.key = key
            el.quantity = .with {
                $0.value = number
                $0.unit = unit
            }
        }
    }
}
