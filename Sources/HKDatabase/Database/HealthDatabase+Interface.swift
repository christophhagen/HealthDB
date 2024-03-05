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
        .notSet
    }

    public func bloodType() throws -> HKBloodType {
        .notSet
    }

    public func dateOfBirthComponents() throws -> DateComponents {
        .init()
    }

    public func fitzpatrickSkinType() throws -> HKFitzpatrickSkinType {
        .notSet
    }

    public func wheelchairUse() throws -> HKWheelchairUse {
        .notSet
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
