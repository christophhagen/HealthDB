import Foundation
import SQLite
import CoreLocation
import HealthKit

typealias Database = Connection

public final class HealthDatabase {

    private let fileUrl: URL

    private let database: Connection

    private let samples: SamplesTable

    private let workoutsTable: WorkoutsTable

    private let locationSamples: LocationSeriesDataTable

    private let dataSeries: DataSeriesTable

    private let keyValueSecure = KeyValueSecureTable()

    public convenience init(fileUrl: URL) throws {
        let database = try Connection(fileUrl.path)
        self.init(fileUrl: fileUrl, database: database)
    }

    init(fileUrl: URL, database: Connection) {
        self.fileUrl = fileUrl
        self.database = database
        self.samples = .init(database: database)
        self.workoutsTable = .init(database: database)
        self.locationSamples = .init(database: database)
        self.dataSeries = .init(database: database)
    }

    func value<T>(for key: String) throws -> T? where T: Value {
        try keyValueSecure.value(for: key, in: database)
    }

    func readAllWorkouts() throws -> [Workout] {
        try workoutsTable.workouts()
    }

    func locationSamples(for activity: HKWorkoutActivity) throws -> [LocationSample] {
        try locationSamples.locationSamples(from: activity.startDate, to: activity.currentEndDate)
    }

    func locationSampleCount(for activity: HKWorkoutActivity) throws -> Int {
        try locationSamples.locationSampleCount(from: activity.startDate, to: activity.currentEndDate)
    }

    func samples(for activity: HKWorkoutActivity) throws -> [SampleType : [Sample]] {
        try samples(from: activity.startDate, to: activity.currentEndDate)
    }

    func samples(from start: Date, to end: Date) throws -> [SampleType : [Sample]] {
        try samples.samples(from: start, to: end).reduce(into: [:]) {
            $0[$1.dataType] = ($0[$1.dataType] ?? []) + [$1]
        }
    }

    func sampleCount(for activity: HKWorkoutActivity) throws -> Int {
        try samples.sampleCount(from: activity.startDate, to: activity.currentEndDate)
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
        try workoutsTable.insert(workout)
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

    func createTables() throws {
        try samples.createAll()
        try workoutsTable.createAll()
        try locationSamples.create(references: dataSeries)
    }
}

private extension HKWorkoutActivity {

    var currentEndDate: Date {
        endDate ?? Date()
    }
}
