import HealthKit
import HealthKitExtensions
import CoreLocation

extension HealthDatabase {
    
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

    // MARK: Samples

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

    // MARK: Locations

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

    // MARK: Statistics

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

    // MARK: Configuration

    /**
     Get the workout configuration for a workout.
     - Parameter workout: The workout for which to get the configuration
     - Returns: The workout configuration, if the workout metadata contains it.
     */
    public func configuration(associatedWith workout: Workout) throws -> WorkoutConfiguration? {
        try store.configuration(associatedWith: workout)
    }

    // MARK: Heart rate zones

    /**
     Get the heart rate zone configuration and the time spent in the different zones for a workout.
     - Parameter workout: The workout of interest
     - Returns: The heart rate zones of the workout
     */
    public func heartRateZones(associatedWith workout: Workout) throws -> [HeartRateZone] {
        try store.heartRateZones(associatedWith: workout)
    }
}
