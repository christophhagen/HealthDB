import Foundation
import HealthKit

extension HKHealthStore: HKHealthStoreInterface {

    /**
     Creates a sample query and executes it.
     */
    public func executeSampleQuery(sampleType: HKSampleType, predicate: NSPredicate?, limit: Int, sortDescriptors: [NSSortDescriptor]?, resultsHandler: @escaping (HKSampleQuery, [HKSample]?, Error?) -> Void) -> HKQuery {
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: limit, sortDescriptors: sortDescriptors, resultsHandler: resultsHandler)
        execute(query)
        return query
    }

#if os(watchOS)
    public func supportsHealthRecords() -> Bool {
        return false
    }

    public func handleAuthorizationForExtension() async throws {
        throw HKNotSupportedError("handleAuthorizationForExtension() is unavailable for WatchOS")
    }
#endif

    public func biologicalSex() throws -> HKBiologicalSex {
        let object: HKBiologicalSexObject = try biologicalSex()
        return object.biologicalSex
    }

    public func bloodType() throws -> HKBloodType {
        let object: HKBloodTypeObject = try bloodType()
        return object.bloodType
    }

    public func fitzpatrickSkinType() throws -> HKFitzpatrickSkinType {
        let object: HKFitzpatrickSkinTypeObject = try fitzpatrickSkinType()
        return object.skinType
    }

    public func wheelchairUse() throws -> HKWheelchairUse {
        let object: HKWheelchairUseObject = try wheelchairUse()
        return object.wheelchairUse
    }
}
