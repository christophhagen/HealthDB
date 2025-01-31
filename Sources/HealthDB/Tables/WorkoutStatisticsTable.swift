import Foundation
import SQLite
import HealthKit

struct WorkoutStatisticsTable {

    let table = Table("workout_statistics")

    func create(in database: Connection, referencing workoutActivities: WorkoutActivitiesTable) throws {
        try database.execute("CREATE TABLE workout_statistics (ROWID INTEGER PRIMARY KEY AUTOINCREMENT, workout_activity_id INTEGER NOT NULL REFERENCES workout_activities(ROWID) ON DELETE CASCADE, data_type INTEGER NOT NULL, quantity REAL NOT NULL, min REAL, max REAL, UNIQUE(workout_activity_id, data_type))")
    }

    let workoutActivityId = SQLite.Expression<Int>("workout_activity_id")

    let dataType = SQLite.Expression<Int>("data_type")

    let quantity = SQLite.Expression<Double>("quantity")

    let min = SQLite.Expression<Double?>("min")

    let max = SQLite.Expression<Double?>("max")
    
    func createStatistics(from row: Row, type: HKQuantityType, unit: HKUnit) -> Statistics {
        .init(quantityType: type,
              average: row[quantity],
              minimum: row[min],
              maximum: row[max],
              unit: unit)
    }

    func createStatistics(from row: Row) throws -> Statistics {
        let rawType = row[dataType]
        guard let identifier = HKQuantityTypeIdentifier(intValue: rawType) else {
            throw HKNotSupportedError("Unknown quantity type \(rawType) for statistics")
        }
        guard let unit = identifier.defaultUnit else {
            throw HKNotSupportedError("Unknown unit for statistics")
        }
        let type = HKQuantityType(identifier)
        return .init(quantityType: type,
              average: row[quantity],
              minimum: row[min],
              maximum: row[max],
                     unit: unit)
    }
}
