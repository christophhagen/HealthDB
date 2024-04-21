import Foundation
import HealthKit

protocol LosslessIntegerConvertible: Hashable {

    static var map: BiDictionary<Self, Int> { get }
}

extension LosslessIntegerConvertible {

    init?(intValue: Int) {
        guard let value = Self.map[value: intValue] else {
            return nil
        }
        self = value
    }

    var intValue: Int? {
        Self.map[key: self]
    }
}
