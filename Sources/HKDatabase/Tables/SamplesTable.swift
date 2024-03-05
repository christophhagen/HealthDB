import Foundation
import SQLite

struct SamplesTable {

    func create(in database: Connection) throws {
        try database.execute("CREATE TABLE samples (data_id INTEGER PRIMARY KEY, start_date REAL, end_date REAL, data_type INTEGER)")
    }

    let table = Table("samples")

    let dataId = Expression<Int>("data_id")

    // NOTE: Technically optional
    let startDate = Expression<Double>("start_date")

    // NOTE: Technically optional
    let endDate = Expression<Double>("end_date")

    let dataType = Expression<Int>("data_type")
}
