import Foundation

public enum Weekday: Int {

    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
}

extension Weekday: CustomStringConvertible {

    public var description: String {
        Calendar.current.weekdaySymbols[rawValue]
    }
}
