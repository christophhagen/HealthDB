import Foundation
import SQLite

struct QuantitySampleSeriesTable {

    private let database: Connection

    init(database: Connection) {
        self.database = database
    }

    let table = Table("quantity_sample_series")

    func create() throws {
        try database.execute("CREATE TABLE quantity_sample_series (data_id INTEGER PRIMARY KEY REFERENCES samples (data_id) ON DELETE CASCADE, count INTEGER NOT NULL DEFAULT 0, insertion_era INTEGER, hfd_key INTEGER UNIQUE NOT NULL, series_location INTEGER NOT NULL)")
    }

    let dataId = Expression<Int>("data_id")

    let count = Expression<Int>("count")

    let insertionEra = Expression<Int?>("insertion_era")

    let hfdKey = Expression<Int>("hfd_key")

    let seriesLocation = Expression<Int>("series_location")
}
