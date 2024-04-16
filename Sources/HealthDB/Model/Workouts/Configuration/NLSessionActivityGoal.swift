import Foundation
import HealthKit

/**
 A helper class to decode parts of workout configuration data.

 This class augments the data format of the binary data in `WorkoutConfiguration.data.goal`, which is encoded using an `NSKeyedUnarchiver`-
 */
final class NLSessionActivityGoal: NSObject, NSSecureCoding {

    static var supportsSecureCoding: Bool = true

    func encode(with coder: NSCoder) {
        fatalError()
    }

    required init?(coder: NSCoder) {
        self.goalType = coder.decodeInteger(forKey: "NLSessionActivityGoalGoalTypeIdentifier")
        self.goalQuantity = coder.decodeObject(of: HKQuantity.self, forKey: "NLSessionActivityGoalQuantity")
        self.goalValue = coder.decodeDouble(forKey: "NLSessionActivityGoalValue")
    }

    let goalType: Int

    let goalQuantity: HKQuantity?

    let goalValue: Double
}
