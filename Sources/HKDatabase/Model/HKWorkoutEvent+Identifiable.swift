import Foundation
import HealthKit
import SwiftProtobuf

extension HKWorkoutEvent: Identifiable {

    public var id: Double {
        dateInterval.start.timeIntervalSinceReferenceDate * Double(type.rawValue) * dateInterval.duration
    }
}
