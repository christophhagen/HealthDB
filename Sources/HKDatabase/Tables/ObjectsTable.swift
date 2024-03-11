import Foundation
import SQLite

struct ObjectsTable {

    func create(referencing dataProvenances: DataProvenancesTable, in database: Connection) throws {
        try database.execute("CREATE TABLE objects (data_id INTEGER PRIMARY KEY AUTOINCREMENT, uuid BLOB UNIQUE, provenance INTEGER NOT NULL REFERENCES data_provenances (ROWID) ON DELETE CASCADE, type INTEGER, creation_date REAL)")
    }

    let table = Table("objects")

    let dataId = Expression<Int>("data_id")

    let uuid = Expression<Data?>("uuid")

    let provenance = Expression<Int>("provenance")
    
    let type = Expression<Int?>("type")
    
    let creationDate = Expression<Double?>("creation_date")
    
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
