import Foundation

/**
 The risk determined by a questionaire
 */
public enum Risk: Int {

    case minimal = 1
    case mild = 2
    case moderate = 3
    case moderatelySevere = 4
    case severe = 5
}

extension Risk: CustomStringConvertible {

    public var description: String {
        switch self {
        case .minimal: return "Minimal"
        case .mild: return "Mild"
        case .moderate: return "Moderate"
        case .moderatelySevere: return "Moderately Severe"
        case .severe: return "Severe"
        }
    }
}
