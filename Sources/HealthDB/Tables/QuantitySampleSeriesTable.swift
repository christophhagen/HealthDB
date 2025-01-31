import Foundation
import SQLite
import HealthKit

struct QuantitySampleSeriesTable {

    let table = Table("quantity_sample_series")

    func create(in database: Connection) throws {
        try database.execute("CREATE TABLE quantity_sample_series (data_id INTEGER PRIMARY KEY REFERENCES samples (data_id) ON DELETE CASCADE, count INTEGER NOT NULL DEFAULT 0, insertion_era INTEGER, hfd_key INTEGER UNIQUE NOT NULL, series_location INTEGER NOT NULL)")
    }

    let dataId = SQLite.Expression<Int>("data_id")

    let count = SQLite.Expression<Int>("count")

    let insertionEra = SQLite.Expression<Int?>("insertion_era")

    let hfdKey = SQLite.Expression<Int>("hfd_key")

    let seriesLocation = SQLite.Expression<Int>("series_location")

    func select(dataId id: Int, in database: Connection, sample: HKQuantitySample, identifier: HKQuantityTypeIdentifier, unit: HKUnit) throws -> HKQuantitySeries? {
        let query = table.filter(dataId == id)
        return try database.pluck(query).map { row in
                .init(
                    dataId: row[dataId],
                    sampleCount: row[count],
                    insertionEra: row[insertionEra],
                    hfdKey: row[hfdKey],
                    seriesLocation: row[seriesLocation],
                    sample: sample,
                    identifier: identifier,
                    unit: unit)
        }
    }

    func select(dataId id: Int, in database: Connection) throws -> (dataId: Int, count: Int, insertionEra: Int?, hfdKey: Int, seriesLocation: Int)? {
        let query = table.filter(dataId == id)
        return try database.pluck(query).map { row in
            (dataId: id,
             count: row[count],
             insertionEra: row[insertionEra],
             hfdKey: row[hfdKey],
             seriesLocation: row[seriesLocation])
        }
    }
}
