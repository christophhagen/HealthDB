import Foundation
import HealthKit

extension SampleType {

    public var hkSampleType: HKSampleType? {
        if let type = HKQuantityTypeIdentifier(sampleType: self) {
            return HKQuantityType(type)
        }
        if let type = HKCategoryTypeIdentifier(sampleType: self) {
            return HKCategoryType(type)
        }
        if let type = HKCorrelationTypeIdentifier(sampleType: self) {
            return HKCorrelationType(type)
        }
        if self == .workout {
            return .workoutType()
        }
        if self == .ecgSample {
            return .electrocardiogramType()
        }
        if self == .workoutRoute {
            return HKSeriesType.workoutRoute()
        }
        if self == .heartBeatSeries {
            return HKSeriesType.heartbeat()
        }
        // return .audiogramSampleType()
        // return .clinicalType(forIdentifier: <#T##HKClinicalTypeIdentifier#>)
        // return .documentType(forIdentifier: <#T##HKDocumentTypeIdentifier#>)
        // return .visionPrescriptionType()
        return nil
    }
}
