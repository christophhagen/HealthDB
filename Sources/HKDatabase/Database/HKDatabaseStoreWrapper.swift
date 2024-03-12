import Foundation
import HealthKit
import HealthKitExtensions
import CoreLocation

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

    public func authorizationStatus(for type: HKObjectTypeContainer.Type) -> HKAuthorizationStatus {
        .sharingAuthorized
    }
    
    public func statusForAuthorizationRequest(toShare typesToShare: [any HealthKitExtensions.HKSampleTypeContainer.Type], read typesToRead: [any HealthKitExtensions.HKObjectTypeContainer.Type]) async throws -> HKAuthorizationRequestStatus {
        .unnecessary
    }

    public static func isHealthDataAvailable() -> Bool {
        true
    }
    
    public func supportsHealthRecords() -> Bool {
        false
    }
    
    public func requestAuthorization(toShare typesToShare: [HKSampleTypeContainer.Type], read typesToRead: [HKObjectTypeContainer.Type]) async throws {
        // Nothing to do, always authorized
    }

    public func requestPerObjectReadAuthorization(for objectType: HKObjectTypeContainer.Type, predicate: NSPredicate?) async throws {
        // Nothing to do, always authorized
    }

    public func handleAuthorizationForExtension() async throws {
        // Nothing to do, always authorized
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

    // MARK: Managing workouts

    /**
     Get all category samples of a single type associated with a workout.
     - Parameter type: The type of category samples to retrieve
     - Parameter workout: The workout for which to get the samples
     - Returns: The category samples of the given type associated with the workout
     */
    public func samples<T>(ofType type: T.Type = T.self, associatedWith workout: Workout) throws -> [T] where T: HKCategorySampleContainer {
        try store.samples(associatedWith: workout, category: T.categoryTypeIdentifier)
            .map(T.init(sample:))
    }

    /**
     Get all quantity samples of a single type associated with a workout.
     - Parameter type: The type of quantity samples to retrieve
     - Parameter workout: The workout for which to get the samples
     - Returns: The quantity samples of the given type associated with the workout
     */
    public func samples<T>(ofType type: T.Type = T.self, associatedWith workout: Workout) throws -> [T] where T: HKQuantitySampleContainer {
        try store.samples(associatedWith: workout, quantity: T.quantityTypeIdentifier)
            .map(T.init(sample:))
    }

    /**
     Get all location samples associated with a workout.
     - Parameter workout: The workout for which to get the locations
     - Returns: The location samples associated with the workout
     */
    public func locations(associatedWith workout: Workout) throws -> [CLLocation] {
        try store.locationSeries(associatedWith: workout)
            .mapAndJoin { try store.locations(in: $0) }
    }
}
