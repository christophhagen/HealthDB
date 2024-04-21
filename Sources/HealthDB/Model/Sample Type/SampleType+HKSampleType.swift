import Foundation
import HealthKit

extension SampleType {

    public var hkSampleType: HKSampleType? {
        switch self {
        case .category(let hKCategoryTypeIdentifier):
            return HKCategoryType(hKCategoryTypeIdentifier)
        case .quantity(let hKQuantityTypeIdentifier):
            return HKQuantityType(hKQuantityTypeIdentifier)
        case .correlation(let hKCorrelationTypeIdentifier):
            return HKCorrelationType(hKCorrelationTypeIdentifier)
        case .other(let otherSampleType):
            switch otherSampleType {
            case .workout:
                return .workoutType()
            case .workoutRoute:
                return HKSeriesType.workoutRoute()
            case .heartbeatSeries:
                return HKSeriesType.heartbeat()
            case .ecgSample:
                return .electrocardiogramType()
            case .audiogram:
                return .audiogramSampleType()
            default:
                return nil
            }
        case .unknown:
            return nil
        }
        // return .clinicalType(forIdentifier: <#T##HKClinicalTypeIdentifier#>)
        // return .documentType(forIdentifier: <#T##HKDocumentTypeIdentifier#>)
        // return .visionPrescriptionType()
    }
}
