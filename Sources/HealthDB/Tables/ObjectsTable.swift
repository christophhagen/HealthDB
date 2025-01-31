import Foundation
import SQLite

struct ObjectsTable {

    func create(in database: Connection, referencing dataProvenances: DataProvenancesTable) throws {
        try database.execute("CREATE TABLE objects (data_id INTEGER PRIMARY KEY AUTOINCREMENT, uuid BLOB UNIQUE, provenance INTEGER NOT NULL REFERENCES data_provenances (ROWID) ON DELETE CASCADE, type INTEGER, creation_date REAL)")
    }

    let table = Table("objects")

    let dataId = SQLite.Expression<Int>("data_id")

    let uuid = SQLite.Expression<Data?>("uuid")

    let provenance = SQLite.Expression<Int>("provenance")

    let type = SQLite.Expression<Int?>("type")

    let creationDate = SQLite.Expression<Double?>("creation_date")
    
    func object(for dataId: Int, in database: Connection) throws -> (uuid: UUID, provenance: Int, type: Int, creationDate: Date)? {
        try database.pluck(table.filter(self.dataId == dataId)).map { row in
            let uuid = row[uuid]!.asUUID()!
            let provenance = row[provenance]
            let type = row[type]!
            let creationDate = Date(timeIntervalSinceReferenceDate: row[creationDate]!)
            return (uuid, provenance, type, creationDate)
        }
    }

    func provenance(for dataId: Int, in database: Connection) throws -> Int? {
        let query = table
            .select(provenance)
            .filter(self.dataId == dataId)
        return try database.pluck(query).map { $0[provenance] }
    }
}
