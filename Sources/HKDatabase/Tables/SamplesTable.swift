import Foundation
import SQLite

struct SamplesTable {

    private let database: Connection

    let quantitySamples: QuantitySamplesTable

    private let objects: ObjectsTable

    private let dataProvenances: DataProvenancesTable

    private let unitStrings: UnitStringsTable

    init(database: Connection) {
        self.database = database
        self.quantitySamples = .init(database: database)
        self.objects = .init(database: database)
        self.dataProvenances = .init(database: database)
        self.unitStrings = .init(database: database)
    }

    func create() throws {
        try database.execute("CREATE TABLE samples (data_id INTEGER PRIMARY KEY, start_date REAL, end_date REAL, data_type INTEGER)")
    }

    func createAll() throws {
        try create()
        try unitStrings.create()
        try quantitySamples.create(referencing: unitStrings)
        try dataProvenances.create()
        try objects.create(referencing: dataProvenances)
    }

    let table = Table("samples")

    let dataId = Expression<Int>("data_id")

    // NOTE: Technically optional
    let startDate = Expression<Double>("start_date")

    // NOTE: Technically optional
    let endDate = Expression<Double>("end_date")

    let dataType = Expression<Int>("data_type")

    enum Column {
        static let dataId = Expression<Int>("data_id")

        // NOTE: Technically optional
        static let startDate = Expression<Double>("start_date")

        // NOTE: Technically optional
        static let endDate = Expression<Double>("end_date")

        static let dataType = Expression<Int>("data_type")
    }

    func samples(from start: Date, to end: Date) throws -> [Sample] {
        let start = start.timeIntervalSinceReferenceDate
        let end = end.timeIntervalSinceReferenceDate

        let selection = table
            .select(table[*],
                    quantitySamples.table[*],
                    dataProvenances.table[dataProvenances.tzName],
                    unitStrings.table[unitStrings.unitString])
            .filter(startDate >= start && endDate <= end)
            .join(.leftOuter, quantitySamples.table, on: table[dataId] == quantitySamples.table[quantitySamples.dataId])
            .join(.leftOuter, objects.table, on: table[dataId] == objects.table[objects.dataId])
            .join(.leftOuter, dataProvenances.table, on: objects.table[objects.provenance] == dataProvenances.table[dataProvenances.rowId])
            .join(.leftOuter, unitStrings.table, on: quantitySamples.table[quantitySamples.originalUnit] == unitStrings.table[unitStrings.rowId])

        return try database.prepare(selection).map { row in
            let startDate = Date(timeIntervalSinceReferenceDate: row[startDate])
            let endDate = Date(timeIntervalSinceReferenceDate: row[endDate])
            let dataType = Sample.DataType(rawValue: row[dataType])
            let quantity = row[quantitySamples.quantity]
            let original = row[quantitySamples.originalQuantity]
            let unit = row[unitStrings.unitString]
            let timeZone = row[dataProvenances.tzName].nonEmpty
            return .init(
                startDate: startDate,
                endDate: endDate,
                dataType: dataType,
                quantity: quantity,
                originalQuantity: original,
                originalUnit: unit,
                timeZoneName: timeZone)
        }
    }

    func sampleCount(from start: Date, to end: Date) throws -> Int {
        let start = start.timeIntervalSinceReferenceDate
        let end = end.timeIntervalSinceReferenceDate
        return try database.scalar(table.filter(startDate >= start && endDate <= end).count)
    }
}
