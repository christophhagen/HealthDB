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

    // MARK: - Accessing HealthKit

    public func authorizationStatus(for type: HKObjectTypeContainer.Type) -> HKAuthorizationStatus {
        store.authorizationStatus(for: type.objectType)
    }

    public func statusForAuthorizationRequest(toShare typesToShare: [HKSampleTypeContainer.Type], read typesToRead: [HKObjectTypeContainer.Type]) async throws -> HKAuthorizationRequestStatus {
        let writableTypes = typesToShare.map { $0.sampleType }
        let readableTypes = typesToRead.map { $0.objectType }
        return try await store.statusForAuthorizationRequest(toShare: Set(writableTypes), read: Set(readableTypes))
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
    
    public func requestAuthorization(toShare typesToShare: [HKSampleTypeContainer.Type], read typesToRead: [HKObjectTypeContainer.Type]) async throws {
        let writableTypes = typesToShare.map { $0.sampleType }
        let readableTypes = typesToRead.map { $0.objectType }
        try await store.requestAuthorization(toShare: Set(writableTypes), read: Set(readableTypes))
    }

    public func requestPerObjectReadAuthorization(for objectType: HKObjectTypeContainer.Type, predicate: NSPredicate?) async throws {
        try await store.requestPerObjectReadAuthorization(for: objectType.objectType, predicate: predicate)
    }

    public func handleAuthorizationForExtension() async throws {
#if os(watchOS)
        throw HKNotSupportedError("handleAuthorizationForExtension() is unavailable for WatchOS")
#else
        try await store.handleAuthorizationForExtension()
#endif
    }

    // MARK: - Querying HealthKit data

    public func samples<T>(ofQuantity quantity: T.Type = T.self, predicate: NSPredicate?, sortDescriptors: [SortDescriptor<HKQuantitySample>], limit: Int?) async throws -> [T] where T : HKQuantitySampleContainer {
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.quantitySample(type: T.quantitySampleType, predicate: predicate)],
            sortDescriptors: sortDescriptors,
            limit: limit)

        let results = try await descriptor.result(for: store)
        return results.map { T.init(sample: $0) }
    }

    public func samples<T>(ofCorrelation correlation: T.Type = T.self, predicate: NSPredicate?, sortDescriptors: [SortDescriptor<HKCorrelation>], limit: Int?) async throws -> [T] where T : HKCorrelationContainer {
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.correlation(type: T.correlationType, predicate: predicate)],
            sortDescriptors: sortDescriptors,
            limit: limit)

        let results = try await descriptor.result(for: store)
        return results.map { T.init(sample: $0) }
    }

    public func samples<T>(ofCategory category: T.Type = T.self, predicate: NSPredicate?, sortDescriptors: [SortDescriptor<HKCategorySample>], limit: Int?) async throws -> [T] where T : HKCategorySampleContainer {
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.categorySample(type: T.categorySampleType, predicate: predicate)],
            sortDescriptors: sortDescriptors,
            limit: limit)

        let results = try await descriptor.result(for: store)
        return results.map { T.init(sample: $0) }
    }

    // MARK: - Reading characteristic data
    
    public func dateOfBirthComponents() throws -> DateComponents {
        try store.dateOfBirthComponents()
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

    // MARK: - Working with HealthKit objects
    
    public func earliestPermittedSampleDate() -> Date {
        store.earliestPermittedSampleDate()
    }

    // MARK: - Accessing the preferred units


    // MARK: - Managing background delivery


    // MARK: - Managing workouts


    // MARK: - Managing workout sessions


    // MARK: - Managing estimates


    // MARK: - Accessing the move mode

    public func activityMoveMode() throws -> HKActivityMoveMode {
        try store.activityMoveMode().activityMoveMode
    }
}
