import Foundation
import HealthKit
import HealthKitExtensions

public final class HKHealthStoreWrapper {

    public let store: HKHealthStore

    public init(wrapping store: HKHealthStore) {
        self.store = store
    }
}

extension HKHealthStoreWrapper: HKHealthStoreInterface {

    public func read<T>(predicate: NSPredicate?, sortDescriptors: [SortDescriptor<HKQuantitySample>], limit: Int?) async throws -> [T] where T : HKQuantitySampleContainer {
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.quantitySample(type: T.quantitySampleType, predicate: predicate)],
            sortDescriptors: sortDescriptors,
            limit: limit)

        let results = try await descriptor.result(for: store)
        return results.map { T.init(sample: $0) }
    }
    
    public func read<T>(predicate: NSPredicate?, sortDescriptors: [SortDescriptor<HKCorrelation>], limit: Int?) async throws -> [T] where T : HKCorrelationContainer {
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.correlation(type: T.correlationType, predicate: predicate)],
            sortDescriptors: sortDescriptors,
            limit: limit)

        let results = try await descriptor.result(for: store)
        return results.map { T.init(sample: $0) }
    }
    
    public func read<T>(predicate: NSPredicate?, sortDescriptors: [SortDescriptor<HKCategorySample>], limit: Int?) async throws -> [T] where T : HKCategorySampleContainer {
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.categorySample(type: T.categorySampleType, predicate: predicate)],
            sortDescriptors: sortDescriptors,
            limit: limit)

        let results = try await descriptor.result(for: store)
        return results.map { T.init(sample: $0) }
    }
    

    public func authorizationStatus(for type: HKObjectType) -> HKAuthorizationStatus {
        store.authorizationStatus(for: type)
    }
    
    public func statusForAuthorizationRequest(toShare typesToShare: Set<HKSampleType>, read typesToRead: Set<HKObjectType>) async throws -> HKAuthorizationRequestStatus {
        try await store.statusForAuthorizationRequest(toShare: typesToShare, read: typesToRead)
    }
    
    public static func isHealthDataAvailable() -> Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    public func supportsHealthRecords() -> Bool {
#if os(watchOS)
        return false
#else
        store.supportsHealthRecords()
#endif
    }
    
    public func requestAuthorization(toShare typesToShare: Set<HKSampleType>, read typesToRead: Set<HKObjectType>) async throws {
        try await store.requestAuthorization(toShare: typesToShare, read: typesToRead)
    }
    
    public func requestPerObjectReadAuthorization(for objectType: HKObjectType, predicate: NSPredicate?) async throws {
        try await store.requestPerObjectReadAuthorization(for: objectType, predicate: predicate)
    }
    
    public func handleAuthorizationForExtension() async throws {
#if os(watchOS)
        throw HKNotSupportedError("handleAuthorizationForExtension() is unavailable for WatchOS")
#else
        try await store.handleAuthorizationForExtension()
#endif
    }
    
    public func dateOfBirthComponents() throws -> DateComponents {
        try store.dateOfBirthComponents()
    }
    
    public func earliestPermittedSampleDate() -> Date {
        store.earliestPermittedSampleDate()
    }

    public func biologicalSex() throws -> HKBiologicalSex {
        try store.biologicalSex().biologicalSex
    }

    public func bloodType() throws -> HKBloodType {
        try store.bloodType().bloodType
    }

    public func fitzpatrickSkinType() throws -> HKFitzpatrickSkinType {
        try store.fitzpatrickSkinType().skinType
    }

    public func wheelchairUse() throws -> HKWheelchairUse {
        try store.wheelchairUse().wheelchairUse
    }

    public func activityMoveMode() throws -> HKActivityMoveMode {
        try store.activityMoveMode().activityMoveMode
    }
}
