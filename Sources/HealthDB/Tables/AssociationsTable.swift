import Foundation
import SQLite

struct AssociationsTable {

    let table = Table("associations")

    let parentId = Expression<Int>("parent_id")

    let childId = Expression<Int>("child_id")

    let syncProvenance = Expression<Int>("sync_provenance")

    let syncIdentity = Expression<Int>("sync_identity")

    func create(in database: Connection) throws {
        try database.run("CREATE TABLE associations (ROWID INTEGER PRIMARY KEY AUTOINCREMENT, parent_id INTEGER, child_id INTEGER, sync_provenance INTEGER, sync_identity INTEGER NOT NULL, UNIQUE(parent_id, child_id))")
    }

    func query(parentId: Int) -> Table {
        table.filter(self.parentId == parentId)
    }
}
