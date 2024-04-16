import Foundation
import HealthKit

extension HKDatabaseStore {
    
    public func biologicalSex() throws -> HKBiologicalSex {
        try value(for: .biologicalSex, fallback: .notSet)
    }

    public func bloodType() throws -> HKBloodType {
        try value(for: .bloodType, fallback: .notSet)
    }

    public func dateOfBirthComponents() throws -> DateComponents {
        guard let value: Double = try value(for:  .dateOfBirth) else {
            return .init()
        }
        let date = Date(timeIntervalSinceReferenceDate: value)
        return Calendar.current.dateComponents([.day, .month, .year], from: date)
    }

    public func fitzpatrickSkinType() throws -> HKFitzpatrickSkinType {
        try value(for: .fitzpatrickSkinType, fallback: .notSet)
    }

    public func wheelchairUse() throws -> HKWheelchairUse {
        try value(for: .wheelchairUse, fallback: .notSet)
    }

    public func activityMoveMode() throws -> HKActivityMoveMode {
        throw HKNotSupportedError("Unknown key for activity move mode in table 'key_value_secure'")
        //try value(for: .activityMoveMode, fallback: .activeEnergy)
    }

    private func value<T>(for key: HKCharacteristicTypeIdentifier, fallback: T) throws -> T where T: RawRepresentable, T.RawValue == Int {
        guard let value: Int = try value(for: key) else {
            return fallback
        }
        return .init(rawValue: value) ?? fallback
    }
}
