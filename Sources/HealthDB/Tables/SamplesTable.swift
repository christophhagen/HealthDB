import Foundation
import SQLite

struct SamplesTable {

    func create(in database: Connection) throws {
        try database.execute("CREATE TABLE samples (data_id INTEGER PRIMARY KEY, start_date REAL, end_date REAL, data_type INTEGER)")
    }

    let table = Table("samples")

    let dataId = SQLite.Expression<Int>("data_id")

    // NOTE: Technically optional
    let startDate = SQLite.Expression<Double>("start_date")

    // NOTE: Technically optional
    let endDate = SQLite.Expression<Double>("end_date")

    let dataType = SQLite.Expression<Int>("data_type")

    /// Select samples of a type overlapping with the given date interval.
    func query(type: SampleType, from start: Date, to end: Date) -> Table {
        let start = start.timeIntervalSinceReferenceDate
        let end = end.timeIntervalSinceReferenceDate
        return table
            .filter(dataType == type.rawValue ?? -1)
            .filter(startDate <= end && endDate >= start)
    }
}
