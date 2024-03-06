import Foundation
import HealthKit

private let df: DateFormatter = {
    let df = DateFormatter()
    df.timeZone = .current
    df.dateStyle = .short
    df.timeStyle = .short
    return df
}()

struct Workout {
    
    let id: Int
    
    /// The distance in km (?)
    let totalDistance: Double?
    
    let goal: Goal?

    let condenserVersion: Int?
    
    let condenserDate: Date?
    
    let events: [HKWorkoutEvent]

    let activities: [HKWorkoutActivity]

    let metadata: [String : Any]

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
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        lhs.id == rhs.id
    }
}

extension Workout: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
