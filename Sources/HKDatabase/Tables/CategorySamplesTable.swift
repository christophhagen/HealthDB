import Foundation
import SQLite

struct CategorySamplesTable {

    let table = Table("category_samples")

    func create(in database: Connection) throws {
        try database.execute("CREATE TABLE category_samples (data_id INTEGER PRIMARY KEY, value INTEGER)")
    }

    let dataId = Expression<Int>("data_id")

    let value = Expression<Int>("value")

    func value(for dataId: Int, in database: Connection) throws -> Int? {
        try database.pluck(table.filter(self.dataId == dataId)).map { $0[value] }
    }
}
