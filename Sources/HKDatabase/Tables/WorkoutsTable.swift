import Foundation
import SQLite
import HealthKit

struct WorkoutsTable {

    private let database: Connection

    let events: WorkoutEventsTable

    let activities: WorkoutActivitiesTable

    let metadata: MetadataTables

    init(database: Connection) {
        self.database = database
        self.events = .init(database: database)
        self.activities = .init(database: database)
        self.metadata = .init(database: database)
    }

    let table = Table("workouts")
    
    // INTEGER PRIMARY KEY AUTOINCREMENT
    let dataId = Expression<Int>("data_id")

    // REAL
    let totalDistance = Expression<Double?>("total_distance")

    // INTEGER
    let goalType = Expression<Int?>("goal_type")

    // REAL
    let goal = Expression<Double?>("goal")

    // INTEGER
    let condenserVersion = Expression<Int?>("condenser_version")

    // REAL
    let condenserDate = Expression<Double?>("condenser_date")

    func workouts() throws -> [Workout] {
        return try database.prepare(table).map { row in
            let id = row[dataId]

            let events = try events.events(for: id, in: database)
            let activities = try activities.activities(for: id)
            let metadata = try metadata.metadata(for: id)
            return .init(
                id: id,
                totalDistance: row[totalDistance],
                goalType: row[goalType],
                goal:  row[goal],
                condenserVersion: row[condenserVersion],
                condenserDate: row[condenserDate].map { Date.init(timeIntervalSinceReferenceDate: $0) },
                events: events,
                activities: activities,
                metadata: metadata)
        }
    }

    func create() throws {
        try database.run(table.create { t in
            t.column(dataId, primaryKey: .autoincrement)
            t.column(totalDistance)
            t.column(goalType)
            t.column(goal)
            t.column(condenserVersion)
            t.column(condenserDate)
        })
        // try database.execute("CREATE TABLE workouts (data_id INTEGER PRIMARY KEY AUTOINCREMENT, total_distance REAL, goal_type INTEGER, goal REAL, condenser_version INTEGER, condenser_date REAL)")
    }

    func createAll() throws {
        try create()
        try events.create(referencing: self)
        try activities.create(referencing: self)
        try metadata.create()
    }

    func insert(_ element: Workout) throws {
        let rowid = try database.run(table.insert(
            totalDistance <- element.totalDistance,
            goalType <- element.goal?.goalType,
            goal <- element.goal?.gaol,
            condenserVersion <- element.condenserVersion,
            condenserDate <- element.condenserDate?.timeIntervalSinceReferenceDate)
        )
        let dataId = Int(rowid)
        for event in element.events {
            try events.insert(event, dataId: dataId)
        }

        for activity in element.activities {
            try activities.insert(activity, isPrimaryActivity: true, dataId: dataId)
        }

        for (key, value) in element.metadata {
            try metadata.insert(value, for: key, of: dataId)
        }
    }
}

