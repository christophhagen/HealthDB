import Foundation
import HealthKit

extension HKCorrelationTypeIdentifier {

    var sampleType: SampleType {
        .correlation(self)
    }
}

extension HKCorrelationTypeIdentifier: LosslessIntegerConvertible {

    static let map: BiDictionary<HKCorrelationTypeIdentifier, Int> = [
        .bloodPressure : 80,
        .food: 81
    ]
}
