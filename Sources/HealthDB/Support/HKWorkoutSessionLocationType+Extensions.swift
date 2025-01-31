import Foundation
import HealthKit

extension HKWorkoutSessionLocationType: @retroactive CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .indoor:
            return "Indoor"
        case .outdoor:
            return "Outdoor"
        @unknown default:
            return "Unknown default"
        }
    }
}
