import Foundation

struct Sample {

    let startDate: Date

    let endDate: Date

    let dataType: DataType

    let quantity: Double?

    let originalQuantity: Double?

    let originalUnit: String?

    let timeZoneName: String?

    var timeZone: TimeZone? {
        guard let timeZoneName else {
            return nil
        }
        guard let zone = TimeZone(identifier: timeZoneName) else {
            print("No time zone for '\(timeZoneName)'")
            return nil
        }
        return zone
    }

    var duration: TimeInterval {
        endDate.timeIntervalSince(startDate)
    }

    var originalQuantityText: String {
        guard let originalQuantity, let originalUnit else {
            return ""
        }
        return " (\(originalQuantity) \(originalUnit))"

    }

    var quantityText: String {
        guard let quantity else {
            return "-"
        }
        return "\(quantity)"
    }

    var dateText: String {
        startDate.timeAndDateText(in: timeZone ?? .current)
    }
}

extension Sample: CustomStringConvertible {

    var description: String {
        "\(dateText) (\(Int(duration)) s) \(quantityText)\(originalQuantityText)"
    }
}

extension Sample {

    enum DataType: RawRepresentable {

        case weight // 3
        case heartRate // 5
        case stepCount // 7
        case distance // 8
        case restingEnergy // 9
        case activeEnergy // 10
        case flightsClimed // 12
        case weeklyCalorieGoal // 67
        case watchOn // 70
        case standMinutes // 75
        case activity // 76
        case workout // 79

        case unknown(Int)

        init(rawValue: Int) {
            switch rawValue {
            case 3: self = .weight
            case 5: self = .heartRate
            case 7: self = .stepCount
            case 8: self = .distance
            case 9: self = .restingEnergy
            case 10: self = .activeEnergy
            case 12: self = .flightsClimed
            case 67: self = .weeklyCalorieGoal
            case 70: self = .watchOn
            case 75: self = .standMinutes
            case 76: self = .activity
            case 79: self = .workout
            default:
                self = .unknown(rawValue)
            }
        }

        var rawValue: Int {
            switch self {
            case .stepCount: return 7
            case .weight: return 3
            case .heartRate: return 5
            case .distance: return 8
            case .restingEnergy: return 9
            case .activeEnergy: return 10
            case .flightsClimed: return 12
            case .weeklyCalorieGoal: return 67
            case .watchOn: return 70
            case .standMinutes: return 75
            case .activity: return 76
            case .workout: return 79
            case .unknown(let value): return value
            }
        }
    }
}

extension Sample.DataType: Equatable {

}

extension Sample.DataType: Hashable {

}

extension Sample.DataType: CustomStringConvertible {

    var description: String {
        switch self {
        case .stepCount: return "Step Count"
        case .weight: return "Weight"
        case .heartRate: return "Heart Rate"
        case .distance: return "Distance"
        case .restingEnergy: return "Resting Energy"
        case .activeEnergy: return "Active Energy"
        case .flightsClimed: return "Flights Climbed"
        case .weeklyCalorieGoal: return "Weekly Calorie Goal"
        case .watchOn: return "Watch On"
        case .standMinutes: return "Stand Minutes"
        case .activity: return "Activity"
        case .workout: return "Workout"
        case .unknown(let int): return "Unknown(\(int))"
        }
    }
}
