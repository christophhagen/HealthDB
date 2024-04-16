import Foundation

/**
 An error for unimplemented features of a ``HKDatabaseStore``
 */
public struct HKNotSupportedError: Error {

    public let message: String

    public init(_ message: String) {
        self.message = message
    }
}
