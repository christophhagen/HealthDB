import Foundation
import SQLite

struct BinarySamplesTable {

    let table = Table("binary_samples")

    func create(in database: Connection, referencing samples: SamplesTable) throws {
        try database.execute("CREATE TABLE binary_samples (data_id INTEGER PRIMARY KEY REFERENCES samples (data_id) ON DELETE CASCADE, payload BLOB)")
    }

    let dataId = SQLite.Expression<Int>("data_id")

    let payload = SQLite.Expression<Data?>("payload")

    func payload(for dataId: Int, in database: Connection) throws -> Data? {
        try database.pluck(table.filter(self.dataId == dataId)).map { $0[payload] }
    }
}
