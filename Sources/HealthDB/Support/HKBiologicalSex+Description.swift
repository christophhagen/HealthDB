import Foundation
import HealthKit

extension HKBiologicalSex: @retroactive CustomStringConvertible {

    public var description: String {
        switch self {
        case .notSet: return "Not Set"
        case .female: return "Female"
        case .male: return "Male"
        case .other: return "Other"
        @unknown default: return "Unknown"
        }
    }
}

