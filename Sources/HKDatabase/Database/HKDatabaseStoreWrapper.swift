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

    /**
     Access category samples in a date interval.
     - Parameter type: The category sample type
     - Parameter start: The beginning of the date range of interest
     - Parameter end: The end of the date range
     */
    public func samples<T>(ofType type: T.Type = T.self, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [T] where T: HKCategorySampleContainer {
        try store.samples(category: T.categoryTypeIdentifier, from: start, to: end)
            .map { T.init(categorySample: $0) }
    }

    /**
     Access category samples in a date interval.
     - Parameter type: The category sample type
     - Parameter predicate: The predicate to filter the samples
     - Parameter sortDescriptors: The descriptors to order the returned samples
     - Parameter limit: The maximum number of samples to return
     */
    public func samples<T>(ofCategory category: T.Type = T.self, predicate: NSPredicate? = nil, sortDescriptors: [SortDescriptor<HKCategorySample>] = [], limit: Int? = nil) throws -> [T] where T : HKCategorySampleContainer {
        try store.samples(category: T.categoryTypeIdentifier)
            .filtered(using: predicate)
            .sorted(using: sortDescriptors)
            .limited(by: limit)
            .map(T.init(categorySample:))
    }

    /**
     Access quantity samples in a date interval.
     - Parameter type: The quantity sample type
     - Parameter start: The beginning of the date range of interest
     - Parameter end: The end of the date range
     */
    public func samples<T>(ofQuantity quantity: T.Type = T.self, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [T] where T: HKQuantitySampleContainer {
        try store.samples(
            quantity: T.quantityTypeIdentifier,
            includingSeriesData: false,
            from: start, to: end,
            unit: T.defaultUnit)
        .map { T.init(quantitySample: $0) }
    }

    /**
     Access quantity samples in a date interval.
     - Parameter type: The quantity sample type
     - Parameter includingSeriesData: Include samples from data series
     - Parameter start: The beginning of the date range of interest
     - Parameter end: The end of the date range
     */
    public func samples<T>(ofQuantity quantity: T.Type = T.self, includingSeriesData: Bool, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [T] where T: HKQuantitySampleContainer {
        try store.samples(
            quantity: T.quantityTypeIdentifier,
            includingSeriesData: includingSeriesData,
            from: start, to: end,
            unit: T.defaultUnit)
        .map { T.init(quantitySample: $0) }
    }

    public func samples<T>(ofQuantity quantity: T.Type = T.self, predicate: NSPredicate?, sortDescriptors: [SortDescriptor<HKQuantitySample>], limit: Int?) throws -> [T] where T : HKQuantitySampleContainer {

        try store.samples(quantity: T.quantityTypeIdentifier)
            .filtered(using: predicate)
            .sorted(using: sortDescriptors)
            .limited(by: limit)
            .map(T.init(quantitySample:))
    }

    public func samples<T>(ofCorrelation correlation: T.Type = T.self, predicate: NSPredicate?, sortDescriptors: [SortDescriptor<HKCorrelation>], limit: Int?) throws -> [T] where T : HKCorrelationContainer {
        try store.correlationSamples(type: T.correlationType)
            .filtered(using: predicate)
            .sorted(using: sortDescriptors)
            .limited(by: limit)
            .map(T.init(correlation:))
    }

    /**
     Query quantity series overlapping a date interval.
     */
    public func series<T>(ofQuantity quantity: T.Type = T.self, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [QuantitySeries<T>] where T: HKQuantitySampleContainer {
        try store.series(quantity: T.quantityTypeIdentifier, unit: T.defaultUnit, from: start, to: end)
            .map { .init(
                dataId: $0.dataId,
                sampleCount: $0.sampleCount,
                insertionEra: $0.insertionEra,
                hfdKey: $0.hfdKey,
                seriesLocation: $0.seriesLocation,
                sample: T.init(quantitySample: $0.sample))
            }
    }

    /**
     Get the quantities associated with a quantity series.

     The returned samples all have the same data type as the original series sample, and include the same `device` and `metadata`.
     */
    public func quantities<T>(in series: QuantitySeries<T>) throws -> [T] {
        try store.quantities(in: series)
            .map(T.init(quantitySample:))
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

    /**
     A list of all key-value pairs.

     Access all entries in the `key_value_secure` table.
     */
    public func keyValuePairs() throws -> [KeyValueEntry] {
        try store.keyValuePairs()
    }

    // MARK: - Working with HealthKit objects

    public func earliestPermittedSampleDate() -> Date {
        .distantPast
    }

    // MARK: Managing workouts

    /**
     All workouts in the database, regardless of type.
     - Parameter start: The start of the date range of interest
     - Parameter end: The end of the date range of interest
     */
    public func workouts(from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [Workout] {
        try store.workouts(from: start, to: end)
    }

    /**
     All workouts with the given activity type.
     - Parameter type: The activity type of interest
     - Parameter start: The start of the date range of interest
     - Parameter end: The end of the date range of interest
     */
    public func workouts(type: HKWorkoutActivityType, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [Workout] {
        try store.workouts(type: type, from: start, to: end)
    }

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
     Get the route associated with a workout.
     - Parameter workout: The workout for which to select the route
     - Returns: The route associated with the workout, if available
     */
    public func route(associatedWith workout: Workout) throws -> WorkoutRoute? {
        try store.route(associatedWith: workout)
    }

    /**
     Get the locations associated with a workout route.
     - Parameter route: The route for which locations are requested
     - Returns: The locations contained in the route
     */
    public func locations(associatedWith route: WorkoutRoute) throws -> [CLLocation] {
        try store.locations(associatedWith: route)
    }

    /**
     Get all location samples associated with a workout.
     - Parameter workout: The workout for which to get the locations
     - Returns: The location samples associated with the workout
     */
    public func locations(associatedWith workout: Workout) throws -> [CLLocation] {
        try route(associatedWith: workout)
            .map { try store.locations(associatedWith: $0) } ?? []
    }

    /**
     Get the statistics associated with a workout activity.
     - Parameter workoutActivity: The activity of interest
     - Returns: A dictionary with the available statistics for the quantity keys
     */
    public func statistics(associatedWith workoutActivity: HKWorkoutActivity) throws -> [HKQuantityType : Statistics] {
        try store.statistics(associatedWith: workoutActivity)
    }

    /**
     Get statistics associated with a workout activity.
     - Parameter type: The type of statistic to select
     - Parameter workoutActivity: The activity of interest
     - Returns: The available statistics for the quantity
     */
    public func statistics<T>(for type: T.Type = T.self, associatedWith workoutActivity: HKWorkoutActivity) throws -> Statistics? where T: HKQuantitySampleContainer {
        try store.statistics(T.quantityTypeIdentifier, associatedWith: workoutActivity, unit: T.defaultUnit)
    }

    /**
     Get the average value for a statistic associated with a workout activity.
     - Parameter type: The type of statistic to select
     - Parameter workoutActivity: The activity of interest
     - Returns: The average quantity
     */
    public func average<T>(for type: T.Type = T.self, associatedWith workoutActivity: HKWorkoutActivity) throws -> HKQuantity? where T: HKQuantitySampleContainer {
        try store.statistics(T.quantityTypeIdentifier, associatedWith: workoutActivity, unit: T.defaultUnit)
            .map { $0.average }
    }

    /**
     Get the minimum value for a statistic associated with a workout activity.
     - Parameter type: The type of statistic to select
     - Parameter workoutActivity: The activity of interest
     - Returns: The minimum quantity
     */
    public func minimum<T>(for type: T.Type = T.self, associatedWith workoutActivity: HKWorkoutActivity) throws -> HKQuantity? where T: HKQuantitySampleContainer {
        try store.statistics(T.quantityTypeIdentifier, associatedWith: workoutActivity, unit: T.defaultUnit)
            .map { $0.minimum }
    }

    /**
     Get the maximum value for a statistic associated with a workout activity.
     - Parameter type: The type of statistic to select
     - Parameter workoutActivity: The activity of interest
     - Returns: The maximum quantity
     */
    public func maximum<T>(for type: T.Type = T.self, associatedWith workoutActivity: HKWorkoutActivity) throws -> HKQuantity? where T: HKQuantitySampleContainer {
        try store.statistics(T.quantityTypeIdentifier, associatedWith: workoutActivity, unit: T.defaultUnit)
            .map { $0.maximum }
    }

    // MARK: ECG Samples

    /**
     Read Electorcardiogram samples.
     - Parameter start: The start date of the interval to search
     - Parameter end: The end date of the interval to search
     - Returns: The samples in the specified date range
     */
    public func electrocardiograms(from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [Electrocardiogram] {
        try store.electrocardiograms(from: start, to: end)
    }

    /**
     Get the voltage measurements associated with an electrocardiogram.
     - Parameter electrocardiogram: The electrocardiogram for which to get voltage measurements
     - Returns: The voltage measurements in the electrocardiogram
     */
    public func voltageMeasurements(associatedWith electrocardiogram: Electrocardiogram) throws -> [HKQuantity] {
        try store.voltageMeasurements(associatedWith: electrocardiogram)
    }
}
