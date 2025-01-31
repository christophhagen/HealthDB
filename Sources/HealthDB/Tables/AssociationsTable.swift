import SQLite

struct AssociationsTable {

    let table = Table("associations")

    let parentId = SQLite.Expression<Int>("parent_id")

    let childId = SQLite.Expression<Int>("child_id")

    let syncProvenance = SQLite.Expression<Int>("sync_provenance")

    let syncIdentity = SQLite.Expression<Int>("sync_identity")

    func create(in database: Connection) throws {
        try database.run("CREATE TABLE associations (ROWID INTEGER PRIMARY KEY AUTOINCREMENT, parent_id INTEGER, child_id INTEGER, sync_provenance INTEGER, sync_identity INTEGER NOT NULL, UNIQUE(parent_id, child_id))")
    }

    func query(parentId: Int) -> Table {
        table.filter(self.parentId == parentId)
    }
}
