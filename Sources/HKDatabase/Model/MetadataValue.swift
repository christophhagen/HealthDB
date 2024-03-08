import Foundation
import HealthKit

enum MetadataValue {

    case string(value: String)
    case number(value: Double)
    case date(value: Date)
    case numerical(value: Double, unit: String)
    case data(value: Data)

    enum ValueType: Int {

        /// Uses only the `string_value` column
        case string = 0

        /// Uses only the `numerical_value` column
        case number = 1

        /// Uses only the `date_value` column
        case date = 2

        /// Uses the `string_value` column for the unit, and the `numerical_value` column for the number
        case numerical = 3

        /// Uses only the `data_value` column
        case data = 4
    }

    var valueType: ValueType {
        switch self {
        case .string: return .string
        case .number: return .number
        case .date: return .date
        case .numerical: return .numerical
        case .data: return .data
        }
    }
}

extension MetadataValue {

    var value: Any {
        switch self {
        case .string(let value):
            return value
        case .number(let value):
            return value
        case .date(let value):
            return value
        case .numerical(let value, let unit):
            return HKQuantity(unit: .init(from: unit), doubleValue: value)
        case .data(let value):
            return value
        }
    }

    init?(value: Any) {
        switch value {
        case let string as String:
            self = .string(value: string)
        case let number as NSNumber:
            self = .number(value: number.doubleValue)
        case let date as Date:
            self = .date(value: date)
        case let quantity as HKQuantity:
            let parts = "\(quantity)".components(separatedBy: " ")
            self = .numerical(value: Double(parts[0])!, unit: parts[1])
        case let data as Data:
            self = .data(value: data)
        default:
            return nil
        }
    }
}

extension MetadataValue: CustomStringConvertible {

    var description: String {
        switch self {
        case .string(let value):
            return value
        case .number(let value):
            return "\(value)"
        case .date(let value):
            return value.timeAndDateText
        case .numerical(let value, let unit):
            return String(format: "%.3f ", value) + unit
        case .data(let value):
            return value.description
        }
    }
}
