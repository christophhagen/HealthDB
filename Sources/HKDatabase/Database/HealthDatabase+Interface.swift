import Foundation
import HealthKit

extension HealthDatabase: HKHealthStoreInterface {

    // MARK: - Accessing HealthKit

    public func authorizationStatus(for type: HKObjectType) -> HKAuthorizationStatus {
        .sharingAuthorized
    }
    
    public func statusForAuthorizationRequest(toShare typesToShare: Set<HKSampleType>, read typesToRead: Set<HKObjectType>) async throws -> HKAuthorizationRequestStatus {
        .unnecessary
    }

    public static func isHealthDataAvailable() -> Bool {
        true
    }
    
    public func supportsHealthRecords() -> Bool {
        false
    }
    
    public func requestAuthorization(toShare typesToShare: Set<HKSampleType>, read typesToRead: Set<HKObjectType>) async throws {
        // Nothing to do, always authorized
    }

    public func requestPerObjectReadAuthorization(for objectType: HKObjectType, predicate: NSPredicate?) async throws {

    }

    public func handleAuthorizationForExtension() async throws {

    }

    // MARK: - Querying HealthKit data

    public func stop(_ query: HKQuery) {
        
    }

    // MARK: - Reading characteristic data

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

    // MARK: - Working with HealthKit objects

    public func delete(_ object: HKObject) async throws {

    }

    public func delete(_ objects: [HKObject]) async throws {

    }

    public func deleteObjects(of objectType: HKObjectType, predicate: NSPredicate) async throws -> Int {
        0
    }


    public func earliestPermittedSampleDate() -> Date {
        .distantPast
    }

    public func save(_ object: HKObject) async throws {

    }

    public func save(_ objects: [HKObject]) async throws {
        
    }


}
