import Foundation
import SQLite
import HealthKit

struct MetadataValuesTable {

    let table = Table("metadata_values")

    let rowId = Expression<Int>("ROW_ID")

    let keyId = Expression<Int?>("key_id")

    let objectId = Expression<Int?>("object_id")

    let valueType = Expression<Int>("value_type")

    let stringValue = Expression<String?>("string_value")

    let numericalValue = Expression<Double?>("numerical_value")

    let dateValue = Expression<Double?>("date_value")

    let dataValue = Expression<Data?>("data_value")

    func all(in database: Connection) throws -> [MetadataValue] {
        try database.prepare(table).map(from)
    }

   func metadata(for workoutId: Int, in database: Connection) throws -> [MetadataValue] {
        try database.prepare(table.filter(objectId == workoutId)).map(from)
    }

   func metadata(for workoutId: Int, in database: Connection) throws -> [(keyId: Int, value: MetadataValue)] {
        try database.prepare(table.filter(objectId == workoutId)).compactMap { row in
            guard let keyId = row[keyId] else {
                print("Found 'key_id == NULL' for metadata value of workout \(workoutId)")
                return nil
            }
            return (keyId, from(row: row))
        }
    }

    func from(row: Row) -> MetadataValue {
        let valueType = MetadataValue.ValueType(rawValue: row[valueType])!
        switch valueType {
        case .string:
            return .string(value: row[stringValue]!)
        case .number:
            return .number(value: row[numericalValue]!)
        case .date:
            return .date(value: .init(timeIntervalSinceReferenceDate: row[dateValue]!))
        case .numerical:
            return .numerical(value: row[numericalValue]!, unit: row[stringValue]!)
        case .data:
            return .data(value: row[dataValue]!)
        }
    }

    func convert(row: Row) -> Any {
        let valueType = MetadataValue.ValueType(rawValue: row[valueType])!
        switch valueType {
        case .string:
            return row[stringValue]!
        case .number:
            return row[numericalValue]! as NSNumber
        case .date:
            return Date(timeIntervalSinceReferenceDate: row[dateValue]!)
        case .numerical:
            return HKQuantity(unit: .init(from: row[stringValue]!), doubleValue: row[numericalValue]!)
        case .data:
            return row[dataValue]!
        }
    }

    func create(in database: Connection) throws {
        //try database.execute("CREATE TABLE metadata_values (ROWID INTEGER PRIMARY KEY AUTOINCREMENT, key_id INTEGER, object_id INTEGER, value_type INTEGER NOT NULL DEFAULT 0, string_value TEXT, numerical_value REAL, date_value REAL, data_value BLOB)")
        try database.run(table.create { table in
            table.column(rowId, primaryKey: .autoincrement)
            table.column(keyId)
            table.column(objectId)
            table.column(valueType, defaultValue: 0)
            table.column(stringValue)
            table.column(numericalValue)
            table.column(dateValue)
            table.column(dataValue)
        })
    }

    func insert(_ value: Any, of workoutId: Int, for keyId: Int) -> Insert {
        let element = MetadataValue(value: value)!
        return table.insert(
            self.keyId <- keyId,
            objectId <- workoutId,
            valueType <- element.valueType.rawValue,
            stringValue <- element.stringValue,
            numericalValue <- element.numericalValue,
            dateValue <- element.dateValue,
            dataValue <- element.dataValue
        )
    }
}

private extension MetadataValue {

    var stringValue: String? {
        if case let .string(value) = self {
            return value
        }
        if case let .numerical(_, unit) = self {
            return unit
        }
        return nil
    }

    var numericalValue: Double? {
        if case let .number(value) = self {
            return value
        }
        if case let .numerical(value: value, unit: _) = self {
            return value
        }
        return nil
    }

    var dateValue: Double? {
        if case let .date(value: date) = self {
            return date.timeIntervalSinceReferenceDate
        }
        return nil
    }

    var dataValue: Data? {
        if case let .data(data) = self {
            return data
        }
        return nil
    }
}
