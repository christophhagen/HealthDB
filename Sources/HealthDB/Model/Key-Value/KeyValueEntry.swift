import Foundation

public struct KeyValueEntry {

    public let category: Int

    public let domain: String

    public let key: String

    /// The value of the entry
    ///
    /// This value can be `Int`, `Double`, `String`, or `Data`
    public let value: Any?

    public let provenance: Int

    public let modificationDate: Date

    public let syncIdentity: Int
}

extension KeyValueEntry: CustomStringConvertible {

    var valueText: String {
        if let value {
            return "\(value)"
        }
        return "-"
    }

    public var description: String {
        "\(key) - \(valueText) (Modified: \(modificationDate), category \(category), domain \(domain), provenance \(provenance), syncIdentity \(syncIdentity))"
    }
}
