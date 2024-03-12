import Foundation
import HealthKit
import HealthKitExtensions

/**
 Wraps a database store to provide a common interface with a ``HKHealthStore``.
 */
public final class HKDatabaseStoreWrapper {

    public let store: HKDatabaseStore

    public init(wrapping store: HKDatabaseStore) {
        self.store = store
    }

    public init(fileUrl: URL) throws {
        self.store = try .init(fileUrl: fileUrl)
    }

}

extension HKDatabaseStoreWrapper: HKHealthStoreInterface {

    // MARK: - Accessing HealthKit

    public func authorizationStatus(for type: HKObjectType) -> HKAuthorizationStatus {
        .sharingAuthorized
    }
    
    public func statusForAuthorizationRequest(toShare typesToShare: Set<HKSampleType>, read typesToRead: Set<HKObjectType>) async throws -> HKAuthorizationRequestStatus {
        .unnecessary
    }

    public static func isHealthDataAvailable() -> Bool {
        true
    }
    
    public func supportsHealthRecords() -> Bool {
        false
    }
    
    public func requestAuthorization(toShare typesToShare: Set<HKSampleType>, read typesToRead: Set<HKObjectType>) async throws {
        // Nothing to do, always authorized
    }

    public func requestPerObjectReadAuthorization(for objectType: HKObjectType, predicate: NSPredicate?) async throws {

    }

    public func handleAuthorizationForExtension() async throws {

    }

    // MARK: - Querying HealthKit data

    public func read<T>(predicate: NSPredicate?, sortDescriptors: [SortDescriptor<HKQuantitySample>], limit: Int?) throws -> [T] where T : HKQuantitySampleContainer {

        try store.quantitySamples(type: T.quantityTypeIdentifier)
            .filtered(using: predicate)
            .sorted(using: sortDescriptors)
            .limited(by: limit)
            .map(T.init(quantitySample:))
    }

    public func read<T>(predicate: NSPredicate?, sortDescriptors: [SortDescriptor<HKCorrelation>], limit: Int?) throws -> [T] where T : HKCorrelationContainer {
        try store.correlationSamples(type: T.correlationType)
            .filtered(using: predicate)
            .sorted(using: sortDescriptors)
            .limited(by: limit)
            .map(T.init(correlation:))
    }

    public func read<T>(predicate: NSPredicate?, sortDescriptors: [SortDescriptor<HKCategorySample>], limit: Int?) throws -> [T] where T : HKCategorySampleContainer {
        try store.categorySamples(type: T.categoryTypeIdentifier)
            .filtered(using: predicate)
            .sorted(using: sortDescriptors)
            .limited(by: limit)
            .map(T.init(categorySample:))
    }

    // MARK: - Reading characteristic data

    public func biologicalSex() throws -> HKBiologicalSex {
        try store.biologicalSex()
    }

    public func bloodType() throws -> HKBloodType {
        try store.bloodType()
    }

    public func dateOfBirthComponents() throws -> DateComponents {
        try store.dateOfBirthComponents()
    }

    public func fitzpatrickSkinType() throws -> HKFitzpatrickSkinType {
        try store.fitzpatrickSkinType()
    }

    public func wheelchairUse() throws -> HKWheelchairUse {
        try store.wheelchairUse()
    }

    public func activityMoveMode() throws -> HKActivityMoveMode {
        try store.activityMoveMode()
    }

    // MARK: - Working with HealthKit objects

    public func earliestPermittedSampleDate() -> Date {
        .distantPast
    }

}
