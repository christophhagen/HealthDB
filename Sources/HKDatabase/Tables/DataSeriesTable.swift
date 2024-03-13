import Foundation
import SQLite

struct DataSeriesTable {

    let table = Table("data_series")

    func create(in database: Connection, referencing samples: SamplesTable) throws {
        try database.execute("CREATE TABLE data_series (data_id INTEGER PRIMARY KEY REFERENCES samples(data_id) ON DELETE CASCADE, frozen INTEGER NOT NULL DEFAULT 0, count INTEGER NOT NULL DEFAULT 0, insertion_era INTEGER NOT NULL DEFAULT 0, hfd_key INTEGER UNIQUE NOT NULL, series_location INTEGER NOT NULL)")
    }

    let dataId = Expression<Int>("data_id")

    let frozen = Expression<Int>("frozen")

    let count = Expression<Int>("count")

    let insertionEra = Expression<Int>("insertion_era")

    let hfdKey = Expression<Int>("hfd_key")

    let seriesLocation = Expression<Int>("series_location")

    func select(dataId id: Int, in database: Connection) throws -> LocationSeries? {
        let query = table.filter(dataId == id)
        return try database.pluck(query).map { row in
                .init(
                    dataId: row[dataId],
                    isFrozen: row[frozen],
                    sampleCount: row[count],
                    insertionEra: row[insertionEra],
                    hfdKey: row[hfdKey],
                    seriesLocation: row[seriesLocation])
        }
    }
}
