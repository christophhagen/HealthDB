import Foundation
import HealthKit

/**
 Workout statistics similar to ``HKStatistics``
 */
public struct Statistics {

    public let quantityType: HKQuantityType

    public let average: HKQuantity

    public let minimum: HKQuantity?

    public let maximum: HKQuantity?

    init(quantityType: HKQuantityType, average: HKQuantity, minimum: HKQuantity?, maximum: HKQuantity?) {
        self.quantityType = quantityType
        self.average = average
        self.minimum = minimum
        self.maximum = maximum
    }

    init(quantityType: HKQuantityType, average: Double, minimum: Double?, maximum: Double?, unit: HKUnit) {
        self.quantityType = quantityType
        self.average = HKQuantity(unit: unit, doubleValue: average)
        self.minimum = minimum.map { HKQuantity(unit: unit, doubleValue: $0) }
        self.maximum = maximum.map { HKQuantity(unit: unit, doubleValue: $0) }
    }
}
