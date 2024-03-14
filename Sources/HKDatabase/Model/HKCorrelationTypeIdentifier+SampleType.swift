import Foundation
import HealthKit

extension HKCorrelationTypeIdentifier {

    init?(sampleType: SampleType) {
        switch sampleType {
        case .bloodPressure: self = .bloodPressure
        default: return nil
        }
    }

    var sampleType: SampleType? {
        switch self {
        case .bloodPressure: return .bloodPressure
        //case .food: return .food
        default: return nil
        }
    }
}
