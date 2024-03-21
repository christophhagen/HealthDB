import Foundation
import HealthKit
import CoreLocation

private let df: DateFormatter = {
    let df = DateFormatter()
    df.timeZone = .current
    df.dateStyle = .short
    df.timeStyle = .short
    return df
}()

public struct Workout {

    public let dataId: Int

    /// The distance in km (?)
    public let totalDistance: Double?

    public let goal: HKQuantity?

    public let startDate: Date

    public let endDate: Date

    public let device: HKDevice?

    public let metadata: [String : Any]

    public let uuid: UUID

    public let workoutEvents: [HKWorkoutEvent]

    public let workoutActivities: [HKWorkoutActivity]

    var firstActivityDate: Date? {
        workoutActivities.map { $0.startDate }.min()
    }
    
    var firstEventDate: Date? {
        workoutEvents.map { $0.dateInterval.start }.min()
    }
    
    var firstAvailableDate: Date? {
        [firstEventDate, firstActivityDate].compactMap { $0 }.min()
    }
    
    var dateString: String {
        guard let firstAvailableDate else {
            return "No date"
        }
        return df.string(from: firstAvailableDate)
    }
    
    var typeString: String {
        workoutActivities.first?.workoutConfiguration.activityType.description ?? "Unknown activity"
    }
    
    public init(dataId: Int, startDate: Date, endDate: Date, totalDistance: Double? = nil, goalType: Int? = nil, goal: Double? = nil, events: [HKWorkoutEvent] = [], activities: [HKWorkoutActivity] = [], uuid: UUID? = nil, metadata: [String : Any] = [:], device: HKDevice? = nil) {
        self.dataId = dataId
        self.startDate = startDate
        self.endDate = endDate
        self.totalDistance = totalDistance
        self.goal = WorkoutGoalType.from(type: goalType, value: goal)
        self.workoutEvents = events
        self.workoutActivities = activities
        self.metadata = metadata
        self.device = device
        self.uuid = uuid ?? UUID()
    }

    /**
     Insert a workout into the Health store.

     - Parameter store: The health store where the workout should be inserted
     - Parameter samples: Additional samples to associate with the workout
     - Parameter route: The workout route to associate with the workout
     - Parameter removeMetadata:Indicate that metadata with known private keys should be stripped from events, activities, and the workout itself
     - Returns: The inserted workout
     - Note: No metadata is altered on associated samples, ven if `removeMetadata` is set to `true`. Be sure to remove all offending keys from sample metadata before inserting a workout, or the insertion will fail.
     */
    public func insert(into store: HKHealthStore, samples: [HKSample] = [], route: [CLLocation] = [], removingPrivateMetadataFields removeMetadata: Bool = false) async throws -> HKWorkout {
        guard removeMetadata else {
            return try await insert(
                into: store,
                activities: workoutActivities,
                events: workoutEvents,
                metadata: metadata,
                samples: samples,
                route: route)
        }
        let metadata = metadata.removingPrivateFields()
        let events = workoutEvents.map {
            HKWorkoutEvent(type: $0.type, dateInterval: $0.dateInterval, metadata: $0.metadata?.removingPrivateFields())
        }
        let activities = workoutActivities.map {
            HKWorkoutActivity(
                workoutConfiguration: $0.workoutConfiguration,
                start: $0.startDate,
                end: $0.endDate,
                metadata: $0.metadata?.removingPrivateFields())
        }

        return try await insert(
            into: store,
            activities: activities,
            events: events,
            metadata: metadata,
            samples: samples,
            route: route)
    }

    private func insert(into store: HKHealthStore, activities: [HKWorkoutActivity], events: [HKWorkoutEvent], metadata: [String : Any], samples: [HKSample], route: [CLLocation]) async throws -> HKWorkout {
        guard let configuration = activities.first?.workoutConfiguration else {
            throw WorkoutInsertionError.noWorkoutActivity
        }
        let builder = HKWorkoutBuilder(healthStore: store, configuration: configuration, device: nil)
        try await builder.beginCollection(at: startDate)

        for activity in activities {
            try await builder.addWorkoutActivity(activity)
        }

        if !events.isEmpty {
            try await builder.addWorkoutEvents(events)
        }
        if !metadata.isEmpty {
            try await builder.addMetadata(metadata)
        }
        if !samples.isEmpty {
            try await builder.addSamples(samples)
        }

        try await builder.endCollection(at: endDate)
        guard let workout = try await builder.finishWorkout() else {
            throw WorkoutInsertionError.failedToFinishWorkout
        }

        guard !route.isEmpty else {
            return workout
        }

        let routeBuilder = HKWorkoutRouteBuilder(healthStore: store, device: workout.device)
        try await routeBuilder.insertRouteData(route)
        try await routeBuilder.finishRoute(with: workout, metadata: nil)
        return workout
    }
}

public enum WorkoutInsertionError: Error {
    /// No workout activity associated with the workout
    case noWorkoutActivity

    /// Failed to finish workout
    case failedToFinishWorkout
}

extension Workout: Equatable {
    public static func == (lhs: Workout, rhs: Workout) -> Bool {
        lhs.dataId == rhs.dataId
    }
}

extension Workout: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(dataId)
    }
}
