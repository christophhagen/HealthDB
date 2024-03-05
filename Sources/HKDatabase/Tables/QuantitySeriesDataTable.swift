import Foundation
import SQLite

struct QuantitySeriesDataTable {

    private let database: Connection

    init(database: Connection) {
        self.database = database
    }

    let table = Table("quantity_series_data")

    func create(referencing samples: SamplesTable) throws {
        try database.execute("CREATE TABLE quantity_series_data (series_identifier INTEGER NOT NULL REFERENCES quantity_sample_series(hfd_key) DEFERRABLE INITIALLY DEFERRED, timestamp REAL NOT NULL, value REAL NOT NULL, duration REAL NOT NULL, PRIMARY KEY (series_identifier, timestamp)) WITHOUT ROWID")
    }

    let seriesIdentifier = Expression<Int>("series_identifier")

    let timestamp = Expression<Double>("timestamp")

    let value = Expression<Double>("value")

    let duration = Expression<Double>("duration")

}
