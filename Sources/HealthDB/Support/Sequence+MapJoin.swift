import Foundation

extension Sequence {

    /**
     Transform all elements and join the resulting sequences together.
     */
    func mapAndJoin<T,S>(_ transform: (Element) throws -> S) rethrows -> [T] where S: Sequence<T> {
        try reduce(into: []) { $0 += try transform($1) }
    }
}
