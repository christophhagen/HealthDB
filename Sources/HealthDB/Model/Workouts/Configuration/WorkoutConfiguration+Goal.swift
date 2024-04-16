import Foundation
import HealthKit

extension WorkoutConfiguration {

    public struct Goal {

        public let goalType: WorkoutGoalType?

        public let goalQuantity: HKQuantity?

        public let goalValue: Double

        init(data: Data) throws {
            NSKeyedUnarchiver.setClass(NLSessionActivityGoal.self, forClassName: "NLSessionActivityGoal")
            guard let object = try NSKeyedUnarchiver.unarchivedObject(ofClass: NLSessionActivityGoal.self, from: data) else {
                throw HKNotSupportedError("Failed to decode activity goal from workout configuration")
            }
            self.goalType = .init(rawValue: object.goalType)
            self.goalQuantity = object.goalQuantity
            self.goalValue = object.goalValue
        }
    }
}
