import Foundation
import SQLite

struct KeyValueSecureTable {
    
    let table = Table("key_value_secure")

    func create(in database: Connection) throws {
        try database.execute("CREATE TABLE key_value_secure (ROWID INTEGER PRIMARY KEY AUTOINCREMENT, category INTEGER NOT NULL, domain TEXT NOT NULL, key TEXT NOT NULL, value, provenance INTEGER NOT NULL, mod_date REAL NOT NULL, sync_identity INTEGER NOT NULL, UNIQUE(category, domain, key))")
    }

    let category = Expression<Int>("category")

    let domain = Expression<String>("domain")

    let key = Expression<String>("key")

    let dataValue = Expression<Data?>("value")
    let intValue = Expression<Int?>("value")

    let provenance = Expression<Int>("provenance")

    let modificationDate = Expression<Double>("mod_date")

    let syncIdentity = Expression<Int>("sync_identity")

    func value<T>(for key: String, in database: Connection) throws -> T? where T: Value {
        try database.pluck(table.filter(self.key == key)).map {
            $0[Expression<T>("value")]
        }
    }

    func all(in database: Connection) throws -> [KeyValueEntry] {
        try database.prepare(table).map(createKeyValueEntry)
    }

    private func createKeyValueEntry(from row: Row) -> KeyValueEntry {
        .init(
            category: row[category],
            domain: row[domain],
            key: row[key],
            value: value(in: row),
            provenance: row[provenance],
            modificationDate: Date(timeIntervalSinceReferenceDate: row[modificationDate]),
            syncIdentity: row[syncIdentity])
    }

    private func value(in row: Row) -> Any? {
        if let int: Int = testType(in: row) {
            return int
        }
        if let double: Double = testType(in: row) {
            return double
        }
        if let string: String = testType(in: row) {
            return string
        }
        if let data: Data = testType(in: row) {
            return data
        }
        return nil
    }

    private func testType<T>(in row: Row) -> T? where T: Value {
        row[Expression<T?>("value")]
    }

}
