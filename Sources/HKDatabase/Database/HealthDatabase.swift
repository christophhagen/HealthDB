import Foundation
import HealthKit
import HealthKitExtensions
import CoreLocation

/**
 Wraps a database store to provide a common interface with a ``HKHealthStore``.
 */
public final class HealthDatabase {

    public let store: HKDatabaseStore

    public init(wrapping store: HKDatabaseStore) {
        self.store = store
    }

    public init(fileUrl: URL) throws {
        self.store = try .init(fileUrl: fileUrl)
    }

}

extension HealthDatabase {
    
    /**
     A list of all key-value pairs.

     Access all entries in the `key_value_secure` table.
     */
    public func keyValuePairs() throws -> [KeyValueEntry] {
        try store.keyValuePairs()
    }
}
