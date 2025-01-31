import Foundation
import SQLite

struct UnitStringsTable {

    func create(in database: Connection) throws {
        try database.execute("CREATE TABLE unit_strings (ROWID INTEGER PRIMARY KEY AUTOINCREMENT, unit_string TEXT UNIQUE)")
    }

    let table = Table("unit_strings")

    let rowId = SQLite.Expression<Int>("ROWID")

    let unitString = SQLite.Expression<String?>("unit_string")

    func unit(for id: Int, database: Connection) throws -> String? {
        guard let row = try database.pluck(table.filter(rowId == id)) else {
            return nil
        }
        return row[unitString]
    }
}
