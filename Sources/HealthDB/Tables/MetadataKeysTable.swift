import SQLite

struct MetadataKeysTable {

    let table = Table("metadata_keys")

    let rowId = SQLite.Expression<Int>("ROWID")

    let key = SQLite.Expression<String>("key")

    func create(in database: Connection) throws {
        //try database.execute("CREATE TABLE metadata_keys (ROWID INTEGER PRIMARY KEY AUTOINCREMENT, key TEXT UNIQUE)")
        try database.run(table.create { table in
            table.column(rowId, primaryKey: .autoincrement)
            table.column(key, unique: true)
        })
    }
}
