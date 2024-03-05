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
}
