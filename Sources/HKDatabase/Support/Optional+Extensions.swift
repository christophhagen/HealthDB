import Foundation

extension Optional {

    @inlinable public func map<U>(_ transform: (Wrapped) throws -> U?) rethrows -> U? {
        guard let wrapped = self else {
            return nil
        }
        return try transform(wrapped)
    }
}

