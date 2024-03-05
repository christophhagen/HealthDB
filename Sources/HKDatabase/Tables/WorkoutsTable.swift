import Foundation
import SQLite
import HealthKit

struct WorkoutsTable {

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

    func create(in database: Connection) throws {
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

    
}

