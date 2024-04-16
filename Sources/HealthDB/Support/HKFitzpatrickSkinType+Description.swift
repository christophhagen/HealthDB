import Foundation
import HealthKit

extension HKFitzpatrickSkinType: CustomStringConvertible {

    public var description: String {
        switch self {
        case .notSet: return "Not Set"
        case .I: return "Type I"
        case .II: return "Type II"
        case .III: return "Type III"
        case .IV: return "Type IV"
        case .V: return "Type V"
        case .VI: return "Type VI"
        @unknown default: return "Unknown"
        }
    }
}

