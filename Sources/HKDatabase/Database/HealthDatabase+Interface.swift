import Foundation
import HealthKit
import HealthKitExtensions

extension HealthDatabase: HealthInterface {

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

    public func samples<T>(
        from start: Date = .distantPast,
        to end: Date = .distantFuture,
        sortedBy sortingMethod: SampleSortingMethod?,
        limitedTo limit: Int?) async throws -> [T] where T : HKCategorySampleContainer {
            try store.samples(category: T.categoryTypeIdentifier, from: start, to: end)
                .filtered(from: start, to: end)
                .sorted(by: sortingMethod)
                .limited(by: limit)
                .map { T.init(categorySample: $0) }
    }

    public func samples<T>(
        from start: Date = .distantPast,
        to end: Date = .distantFuture,
        sortedBy sortingMethod: SampleSortingMethod?,
        limitedTo limit: Int?) async throws -> [T] where T : HKQuantitySampleContainer {
            try store.samples(quantity: T.quantityTypeIdentifier, from: start, to: end)
                .filtered(from: start, to: end)
                .sorted(by: sortingMethod)
                .limited(by: limit)
                .map { T.init(quantitySample: $0) }
    }

    

    public func samples<T>(
        from start: Date = .distantPast,
        to end: Date = .distantFuture,
        sortedBy sortingMethod: SampleSortingMethod?,
        limitedTo limit: Int?) async throws -> [T] where T : HKCorrelationContainer {
            try store.samples(correlation: T.correlationTypeIdentifier, from: start, to: end)
                .filtered(from: start, to: end)
                .sorted(by: sortingMethod)
                .limited(by: limit)
                .map { T.init(correlation: $0) }
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
