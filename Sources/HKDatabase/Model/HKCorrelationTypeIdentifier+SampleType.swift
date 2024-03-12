import Foundation
import HealthKit

extension HKCorrelationTypeIdentifier {

    var sampleType: SampleType? {
        switch self {
        case .bloodPressure: return .bloodPressure
        //case .food: return .food
        default: return nil
        }
    }
}
