import Foundation

enum Goal {

    case time(TimeInterval)

    init?(goalType: Int?, goal: Double?) {
        switch goalType {
        case .none:
            return nil
        case 0:
            return nil
        case 2:
            guard let goal else {
                print("Time goal, but no goal value set")
                return nil
            }
            self = .time(goal)
        default:
            return nil
        }
    }

    var gaol: Double {
        switch self {
        case .time(let timeInterval):
            return timeInterval
        }
    }

    var goalType: Int {
        switch self {
        case .time: return 2
        }
    }
}

extension Goal: CustomStringConvertible {

    var description: String {
        switch self {
        case .time(let seconds):
            return seconds.durationString
        }
    }
}
