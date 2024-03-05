import Foundation
import SQLite

struct MetadataTables {

    private let database: Connection

    let values: MetadataValuesTable

    let keys: MetadataKeysTable

    init(database: Connection) {
        self.database = database
        self.keys = .init(database: database)
        self.values = .init(database: database)
    }

    func create() throws {
        try values.create()
        try keys.create()
    }

    func metadata(for workoutId: Int) throws -> [Metadata.Key : Metadata.Value] {
        // Keys: rowId -> String

        let selection = values.table
            .select(values.table[*], keys.table[keys.key])
            .filter(values.objectId == workoutId)
            .join(.leftOuter, keys.table, on: values.table[values.keyId] == keys.table[keys.rowId])

        return try database.prepare(selection).reduce(into: [:]) { dict, row in
            let key = Metadata.Key(rawValue: row[keys.key])
            let value = values.from(row: row)
            dict[key] = value
        }
    }

    func insert(_ value: Metadata.Value, for key: Metadata.Key, of workoutId: Int) throws {
        let keyId = try keys.hasKey(key) ?? keys.insert(key: key)
        try values.insert(value, of: workoutId, for: keyId)
    }
}
