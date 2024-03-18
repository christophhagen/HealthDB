import Foundation
import HealthKitExtensions

extension Metadata {

    public func removingPrivateFields() -> Metadata {
        filter { (key, _) in
            HKMetadataPrivateKey(rawValue: key) == nil
        }
    }

    public func value<T>(forPrivateKey key: HKMetadataPrivateKey, as type: T.Type = T.self) -> T? {
        self[key.rawValue] as? T
    }
}
