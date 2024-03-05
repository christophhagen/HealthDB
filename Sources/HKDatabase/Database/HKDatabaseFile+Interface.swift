import Foundation
import HealthKit

struct HKNotSupportedError: Error {

}

extension HealthDatabase {

    public func executeSampleQuery(sampleType: HKSampleType, predicate: NSPredicate?, limit: Int, sortDescriptors: [NSSortDescriptor]?, resultsHandler: @escaping (HKSampleQuery, [HKSample]?, Error?) -> Void) -> HKQuery {
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: limit, sortDescriptors: sortDescriptors, resultsHandler: resultsHandler)

        switch sampleType {
        case is HKWorkoutType:
            workouts(predicate: predicate, limit: limit, sortDescriptors: sortDescriptors, resultsHandler: resultsHandler)
            return query
        case is HKCorrelationType:
            // TODO: Implement
            break
        case is HKQuantityType:
            // TODO: Implement
            break
        case is HKAudiogramSampleType:
            // TODO: Implement
            break
        case is HKElectrocardiogramType:
            // TODO: Implement
            break
        case is HKPrescriptionType:
            // TODO: Implement
            break
        case is HKClinicalType:
            // TODO: Implement
            break
        case is HKCategoryType:
            // TODO: Implement
            break
        case is HKDocumentType:
            // TODO: Implement
            break
        case is HKSeriesType:
            // TODO: Implement
            break
        //case is HKCharacteristicType:
        //    break
        //case is HKActivitySummaryType:
        //    break
        default:
            break
        }

        resultsHandler(query, nil, HKNotSupportedError())
        return query

        //sampleType.isMinimumDurationRestricted
        //sampleType.isMaximumDurationRestricted
        //sampleType.maximumAllowedDuration
        //sampleType.allowsRecalibrationForEstimates
    }

    private func workouts(predicate: NSPredicate?, limit: Int, sortDescriptors: [NSSortDescriptor]?, resultsHandler: @escaping (HKSampleQuery, [HKSample]?, Error?) -> Void) {
        #warning("Get workouts and filter them")

        // let a: NSArray = [HKWorkoutEvent]() as NSArray
        // a.filtered(using: predicate!)

        // Example predicates
        // HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, duration: 1)
        // HKQuery.predicateForWorkouts(with: HKWorkoutActivityType)
    }
}
