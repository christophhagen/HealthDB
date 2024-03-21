import Foundation

final class FIUIWorkoutActivityType: NSObject, NSSecureCoding {

    static var supportsSecureCoding: Bool = true

    func encode(with coder: NSCoder) {
        fatalError()
    }

    required init?(coder: NSCoder) {
        guard let dict = coder.decodeDictionary(
            withKeysOfClasses: [NSString.self],
            objectsOfClasses: [NSDate.self, NSString.self], forKey: "FIUIWorkoutActivityTypeMetadata") else {
            print("Could not find dictionary 'FIUIWorkoutActivityTypeMetadata' while decoding workout configuration activity type")
            return nil
        }
        if let uuidString = dict["PredictionSessionUUID"] as? String,
           let uuid = UUID(uuidString: uuidString) {
            self.uuid = uuid
        } else {
            self.uuid = nil
        }
        if let backdatedStartDate = dict["BackdatedStartDate"] as? Date {
            self.backdatedStartDate = backdatedStartDate
        } else {
            self.backdatedStartDate = nil
        }
        self.isPartOfMultisport = coder.decodeBool(forKey: "FIUIWorkoutActivityTypePartOfMultisport")
        self.isIndoorWorkout = coder.decodeBool(forKey: "FIUIWorkoutActivityTypeIsIndoor")
        self.auxiliaryActivityType = coder.decodeInteger(forKey: "NLSessionAuxiliaryActivityTypeIdentifier")
        self.activityTypeLocation = coder.decodeInteger(forKey: "FIUIWorkoutActivityTypeLocation")
        self.workoutActivityType = coder.decodeInteger(forKey: "FIUIWorkoutActivityTypeIdentifier")
    }

    let uuid: UUID?

    let isIndoorWorkout: Bool

    let auxiliaryActivityType: Int

    let isPartOfMultisport: Bool

    let activityTypeLocation: Int

    let workoutActivityType: Int

    let backdatedStartDate: Date?
}
