import Foundation
import SQLite
import CoreLocation
import HealthKit

typealias Database = Connection

public final class HealthDatabase {

    private let fileUrl: URL

    private let database: Connection

    private let tables: Tables

    public convenience init(fileUrl: URL) throws {
        let database = try Connection(fileUrl.path)
        self.init(fileUrl: fileUrl, database: database)
    }

    init(fileUrl: URL, database: Connection) {
        self.fileUrl = fileUrl
        self.database = database
        self.tables = .init(database: database)
    }

    func value<T>(for key: String) throws -> T? where T: Value {
        try tables.value(for: key)
    }

    func readAllWorkouts() throws -> [Workout] {
        try tables.allWorkouts()
    }

    func locationSamples(for activity: HKWorkoutActivity) throws -> [LocationSample] {
        try tables.locationSamples(from: activity.startDate, to: activity.currentEndDate, in: database)
    }

    func locationSampleCount(for activity: HKWorkoutActivity) throws -> Int {
        try tables.locationSampleCount(from: activity.startDate, to: activity.currentEndDate, in: database)
    }

    func samples(for activity: HKWorkoutActivity) throws -> [SampleType : [Sample]] {
        try samples(from: activity.startDate, to: activity.currentEndDate)
    }

    func samples(from start: Date, to end: Date) throws -> [SampleType : [Sample]] {
        try tables.samples(from: start, to: end).reduce(into: [:]) {
            $0[$1.dataType] = ($0[$1.dataType] ?? []) + [$1]
        }
    }

    func sampleCount(for activity: HKWorkoutActivity) throws -> Int {
        try tables.sampleCount(from: activity.startDate, to: activity.currentEndDate)
    }

    func metadata(for objectId: Int) throws -> [Metadata.Key : Metadata.Value] {
        try tables.metadata(for: objectId)
    }

    private func testActivityOverlap() throws {
        let workouts = try readAllWorkouts()
        let activities = workouts.map { $0.activities }.joined().sorted()
        var current = activities.first!
        for next in activities.dropFirst() {
            let overlap = next.startDate.timeIntervalSince(current.currentEndDate)
            if overlap < 0 {
                print("Overlap \(-overlap.roundedInt) s:")
                print("    Activity \(current.workoutConfiguration.activityType): \(current.startDate) -> \(current.currentEndDate)")
                print("    Activity \(next.workoutConfiguration.activityType): \(next.startDate) -> \(next.currentEndDate)")
            }
            current = next
        }
    }

    convenience init(database: Database) {
        self.init(fileUrl: .init(filePath: "/"), database: database)
    }

    func insert(workout: Workout) throws {
        try tables.insert(workout: workout)
    }

    func insert(workout: Workout, into store: HKHealthStore) async throws -> HKWorkout? {
        guard let configuration = workout.activities.first?.workoutConfiguration else {
            return nil
        }

        let builder = HKWorkoutBuilder(healthStore: store, configuration: configuration, device: nil)
        let metadata = workout.metadata.reduce(into: [:]) { dict, element in
            dict[element.key.rawValue] = element.value.value
        }
        try await builder.addMetadata(metadata)
        //try await builder.addSamples(<#T##samples: [HKSample]##[HKSample]#>)
        try await builder.addWorkoutEvents(workout.events)
        for activity in workout.activities {
            try await builder.addWorkoutActivity(activity)
        }
        return try await builder.finishWorkout()
    }
}

private extension HKWorkoutActivity {

    var currentEndDate: Date {
        endDate ?? Date()
    }
}
