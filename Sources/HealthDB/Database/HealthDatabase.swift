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

    /**
     Open a health database.
     - Parameter fileUrl: The url to the sqlite file
     - Parameter readOnly: Indicate if the database should be writable
     */
    public init(fileUrl: URL, readOnly: Bool = true) throws {
        self.store = try .init(fileUrl: fileUrl, readOnly: readOnly)
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
