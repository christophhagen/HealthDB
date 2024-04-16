import Foundation
import HealthKit

public protocol HKSampleProtocol: HKObjectProtocol {

    /// The sample’s start date.
    var startDate: Date { get }

    ///The sample’s end date.
    var endDate: Date { get }

    /// The sample type.
    var sampleType: HKSampleType { get }

}

extension HKSampleProtocol {

    ///Indicates whether the sample has an unknown duration.
    var hasUndeterminedDuration: Bool {
        endDate == .distantFuture
    }

    var duration: TimeInterval {
        endDate.timeIntervalSince(startDate)
    }
}
