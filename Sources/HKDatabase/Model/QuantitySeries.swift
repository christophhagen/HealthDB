import Foundation
import HealthKit
import HealthKitExtensions

public protocol QuantitySeries {

    var dataId: Int { get }

    var sampleCount: Int { get }

    var insertionEra: Int? { get }

    var hfdKey: Int { get }

    var seriesLocation: Int { get }

    var identifier: HKQuantityTypeIdentifier { get }

    var unit: HKUnit { get }
}

public struct HKQuantitySeries: QuantitySeries {

    public let dataId: Int

    public let sampleCount: Int

    public let insertionEra: Int?

    public let hfdKey: Int

    public let seriesLocation: Int

    public let sample: HKQuantitySample

    public let identifier: HKQuantityTypeIdentifier

    public let unit: HKUnit
}


public struct TypedQuantitySeries<T>: QuantitySeries where T: HKQuantitySampleContainer {

    public let dataId: Int

    public let sampleCount: Int

    public let insertionEra: Int?

    public let hfdKey: Int

    public let seriesLocation: Int

    public let sample: T

    var series: HKQuantitySeries {
        .init(dataId: dataId, sampleCount: sampleCount, insertionEra: insertionEra, hfdKey: hfdKey, seriesLocation: seriesLocation, sample: sample.quantitySample, identifier: T.quantityTypeIdentifier, unit: T.defaultUnit)
    }

    public var identifier: HKQuantityTypeIdentifier {
        T.quantityTypeIdentifier
    }

    public var unit: HKUnit {
        T.defaultUnit
    }
}
