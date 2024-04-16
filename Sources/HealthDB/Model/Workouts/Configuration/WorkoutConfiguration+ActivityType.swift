import Foundation
import HealthKit

extension WorkoutConfiguration {

    public struct ActivityType {

        public let uuid: UUID?

        public let isIndoorWorkout: Bool

        public let auxiliaryActivityType: HKWorkoutActivityType? //Int

        public let isPartOfMultisport: Bool

        public let activityTypeLocation: Int

        public let workoutActivityType: HKWorkoutActivityType //Int

        public let backdatedStartDate: Date?

        init(data: Data) throws {
            NSKeyedUnarchiver.setClass(FIUIWorkoutActivityType.self, forClassName: "FIUIWorkoutActivityType")
            guard let object = try NSKeyedUnarchiver.unarchivedObject(ofClass: FIUIWorkoutActivityType.self, from: data) else {
                throw HKNotSupportedError("Failed to decode workout configuration activity type")
            }
            self.uuid = object.uuid
            self.isIndoorWorkout = object.isIndoorWorkout
            if object.auxiliaryActivityType != 0 {
                self.auxiliaryActivityType = HKWorkoutActivityType(rawValue: UInt(object.auxiliaryActivityType))!
            } else {
                self.auxiliaryActivityType = nil
            }
            self.isPartOfMultisport = object.isPartOfMultisport
            self.activityTypeLocation = object.activityTypeLocation
            self.workoutActivityType = HKWorkoutActivityType(rawValue: UInt(object.workoutActivityType))! // object.workoutActivityType
            self.backdatedStartDate = object.backdatedStartDate
        }
    }
}
