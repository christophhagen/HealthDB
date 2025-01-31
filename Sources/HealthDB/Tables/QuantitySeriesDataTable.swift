import Foundation
import SQLite
import HealthKit

struct QuantitySeriesDataTable {

    let table = Table("quantity_series_data")

    func create(in database: Connection, referencing samples: SamplesTable) throws {
        try database.execute("CREATE TABLE quantity_series_data (series_identifier INTEGER NOT NULL REFERENCES quantity_sample_series(hfd_key) DEFERRABLE INITIALLY DEFERRED, timestamp REAL NOT NULL, value REAL NOT NULL, duration REAL NOT NULL, PRIMARY KEY (series_identifier, timestamp)) WITHOUT ROWID")
    }

    let seriesIdentifier = SQLite.Expression<Int>("series_identifier")

    let timestamp = SQLite.Expression<Double>("timestamp")

    let value = SQLite.Expression<Double>("value")

    let duration = SQLite.Expression<Double>("duration")

    func quantities(for dataId: Int, in database: Connection, identifier: HKQuantityTypeIdentifier, unit: HKUnit) throws -> [HKQuantitySample] {
        let query = table.filter(seriesIdentifier == dataId)
        return try database.prepare(query).map { row in
            let start = Date(timeIntervalSinceReferenceDate: row[timestamp])
            let end = start.addingTimeInterval(row[duration])
            return .init(
                type: .init(identifier),
                quantity: .init(unit: unit, doubleValue: row[value]),
                start: start,
                end: end)
        }
    }

    func quantities(for dataId: Int, in database: Connection) throws -> [(value: Double, start: Date, end: Date)] {
        let query = table.filter(seriesIdentifier == dataId)
        return try database.prepare(query).map { row in
            let start = Date(timeIntervalSinceReferenceDate: row[timestamp])
            let end = start.addingTimeInterval(row[duration])
            let value = row[value]
            return (value, start, end)
        }
    }
}
