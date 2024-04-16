import Foundation
import HealthKit

extension HKCharacteristicTypeIdentifier {

    var databaseKey: String? {
        switch self {
        case .biologicalSex: return "sex"
        case .bloodType: return "blood_type"
        case .dateOfBirth: return "birthdate"
        case .fitzpatrickSkinType: return "fitzpatrick_skin_type"
        case .wheelchairUse: return "wheelchair_use"
        case .activityMoveMode: return "activity_move_mode" // TODO: Figure out correct database key
        default: return nil
        }
    }
}
