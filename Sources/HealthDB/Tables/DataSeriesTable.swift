import SQLite

struct DataSeriesTable {

    let table = Table("data_series")

    func create(in database: Connection, referencing samples: SamplesTable) throws {
        try database.execute("CREATE TABLE data_series (data_id INTEGER PRIMARY KEY REFERENCES samples(data_id) ON DELETE CASCADE, frozen INTEGER NOT NULL DEFAULT 0, count INTEGER NOT NULL DEFAULT 0, insertion_era INTEGER NOT NULL DEFAULT 0, hfd_key INTEGER UNIQUE NOT NULL, series_location INTEGER NOT NULL)")
    }

    let dataId = SQLite.Expression<Int>("data_id")

    let frozen = SQLite.Expression<Int>("frozen")

    let count = SQLite.Expression<Int>("count")

    let insertionEra = SQLite.Expression<Int>("insertion_era")

    let hfdKey = SQLite.Expression<Int>("hfd_key")

    let seriesLocation = SQLite.Expression<Int>("series_location")
}
