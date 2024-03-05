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
        try value(key: "sex", fallback: .notSet)
    }

    public func bloodType() throws -> HKBloodType {
        try value(key: "blood_type", fallback: .notSet)
    }

    public func dateOfBirthComponents() throws -> DateComponents {
        guard let value: Double = try value(for:  "birthdate") else {
            return .init()
        }
        let date = Date(timeIntervalSinceReferenceDate: value)
        return Calendar.current.dateComponents([.day, .month, .year], from: date)
    }

    public func fitzpatrickSkinType() throws -> HKFitzpatrickSkinType {
        try value(key: "fitzpatrick_skin_type", fallback: .notSet)
    }

    public func wheelchairUse() throws -> HKWheelchairUse {
        try value(key: "wheelchair_use", fallback: .notSet)
    }

    private func value<T>(key: String, fallback: T) throws -> T where T: RawRepresentable, T.RawValue == Int {
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
