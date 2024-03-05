import Foundation
import SQLite

struct MetadataKeysTable {

    private let database: Connection

    init(database: Connection) {
        self.database = database
    }

    let table = Table("metadata_keys")

    let rowId = Expression<Int>("ROWID")

    let key = Expression<String>("key")

    func key(for keyId: Int, in database: Connection) throws -> String {
        try database.pluck(table.filter(rowId == keyId)).map { $0[key] }!
    }

    func all() throws -> [Int : Metadata.Key] {
        try database.prepare(table).reduce(into: [:]) {  dict, row in
            dict[row[rowId]] = .init(rawValue: row[key])
        }
    }

    func create() throws {
        //try database.execute("CREATE TABLE metadata_keys (ROWID INTEGER PRIMARY KEY AUTOINCREMENT, key TEXT UNIQUE)")
        try database.run(table.create { table in
            table.column(rowId, primaryKey: .autoincrement)
            table.column(key, unique: true)
        })
    }

    func hasKey(_ key: Metadata.Key) throws -> Int? {
        try database.pluck(table.filter(self.key == key.rawValue)).map { $0[rowId] }
    }

    func insert(key: Metadata.Key) throws -> Int {
        Int(try database.run(table.insert(self.key <- key.rawValue)))
    }

}
