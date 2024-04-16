import Foundation
import HealthKit

public enum WorkoutGoalType: Int {
    case distance = 1
    case duration = 2
    case activeEnergy = 3

    public func quantity(for value: Double) -> HKQuantity {
        switch self {
        case .distance: return .init(unit: .meterUnit(with: .kilo), doubleValue: value)
        case .duration: return .init(unit: .second(), doubleValue: value)
        case .activeEnergy: return .init(unit: .kilocalorie(), doubleValue: value)
        }
    }

    static func from(type: Int?, value: Double?) -> HKQuantity? {
        guard let value else {
            return nil
        }
        guard let type, type != 0 else {
            return nil
        }
        guard let goalType = WorkoutGoalType(rawValue: type) else {
            print("Unknown workout goal type \(type) (value: \(value))")
            return nil
        }
        return goalType.quantity(for: value)
    }

    static func values(for goal: HKQuantity?) -> (type: Int?, goal: Double?) {
        guard let goal else {
            return (nil, nil)
        }
        if goal.is(compatibleWith: .meter()) {
            return (1, goal.doubleValue(for: .meterUnit(with: .kilo)))
        }
        if goal.is(compatibleWith: .second()) {
            return (2, goal.doubleValue(for: .second()))
        }
        if goal.is(compatibleWith: .kilocalorie()) {
            return (3, goal.doubleValue(for: .kilocalorie()))
        }
        return (nil, nil)
    }
}
