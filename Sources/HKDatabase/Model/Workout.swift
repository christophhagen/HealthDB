import Foundation
import HealthKit

private let df: DateFormatter = {
    let df = DateFormatter()
    df.timeZone = .current
    df.dateStyle = .short
    df.timeStyle = .short
    return df
}()

public struct Workout {

    public let id: Int

    /// The distance in km (?)
    public let totalDistance: Double?

    public let goal: Goal?

    let condenserVersion: Int?

    let condenserDate: Date?
    
    public let events: [HKWorkoutEvent]

    public let activities: [HKWorkoutActivity]

    public let metadata: [String : Any]

    var firstActivityDate: Date? {
        activities.map { $0.startDate }.min()
    }
    
    var firstEventDate: Date? {
        events.map { $0.dateInterval.start }.min()
    }
    
    var firstAvailableDate: Date? {
        [condenserDate, firstEventDate, firstActivityDate].compactMap { $0 }.min()
    }
    
    var dateString: String {
        guard let firstAvailableDate else {
            return "No date"
        }
        return df.string(from: firstAvailableDate)
    }
    
    var typeString: String {
        activities.first?.workoutConfiguration.activityType.description ?? "Unknown activity"
    }
    
    init(id: Int, totalDistance: Double? = nil, goalType: Int? = nil, goal: Double? = nil, condenserVersion: Int? = nil, condenserDate: Date? = nil, events: [HKWorkoutEvent] = [], activities: [HKWorkoutActivity] = [], metadata: [String : Any] = [:]) {
        self.id = id
        self.totalDistance = totalDistance
        self.goal = .init(goalType: goalType, goal: goal)
        self.condenserVersion = condenserVersion
        self.condenserDate = condenserDate
        self.events = events
        self.activities = activities
        self.metadata = metadata
    }
}

extension Workout: Identifiable { }

extension Workout: Equatable {
    public static func == (lhs: Workout, rhs: Workout) -> Bool {
        lhs.id == rhs.id
    }
}

extension Workout: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
