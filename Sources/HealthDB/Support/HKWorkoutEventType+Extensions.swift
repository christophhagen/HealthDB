import Foundation
import HealthKit

extension HKWorkoutEventType: @retroactive CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .pause: return "Pause"
        case .resume: return "Resume"
        case .lap: return "Lap"
        case .marker: return "Marker"
        case .motionPaused: return "Motion Paused"
        case .motionResumed: return "Motion Resumed"
        case .segment: return "Segment"
        case .pauseOrResumeRequest: return "Pause or Resume Request"
        @unknown default:
            return "Unknown"
        }
    }
}
