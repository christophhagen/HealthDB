import Foundation
import HealthKit

extension Metadata {

    enum Value {

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
}

extension Metadata.Value {

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
}

extension Metadata.Value: CustomStringConvertible {
    
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
