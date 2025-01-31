import Foundation
import HealthKit

extension HKWorkoutSwimmingLocationType: @retroactive CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .pool:
            return "Pool"
        case .openWater:
            return "Open Water"
        @unknown default:
            return "Unknown default"
        }
    }
}
