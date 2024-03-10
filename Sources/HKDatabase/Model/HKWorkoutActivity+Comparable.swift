import Foundation
import HealthKit

extension HKWorkoutActivity {

    var currentEndDate: Date {
        endDate ?? Date()
    }
}

extension HKWorkoutActivity: Comparable {

    public static func < (lhs: HKWorkoutActivity, rhs: HKWorkoutActivity) -> Bool {
        lhs.startDate < rhs.startDate
    }
}

extension HKWorkoutActivity {

    var externalUUID: UUID? {
        guard let string = metadata?[HKMetadataKeyExternalUUID] as? String else {
            return nil
        }
        return UUID(uuidString: string)
    }

    var preferredUUID: UUID {
        externalUUID ?? uuid
    }

    var cleanMetadata: [String : Any] {
        metadata?.filter { $0.key != HKMetadataKeyExternalUUID } ?? [:]
    }

    var hasMetadata: Bool {
        switch metadata?.count {
        case 0:
            return false
        case 1:
            return metadata?[HKMetadataKeyExternalUUID] == nil
        default:
            return true
        }
    }
}
