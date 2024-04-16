import Foundation
import HealthKit

/**
 A type equivalent to an ``HKElectrocardiogram``
 */
public struct Electrocardiogram: HKSampleProtocol {

    let dataId: Int

    public let symptomsStatus: HKElectrocardiogram.SymptomsStatus

    public let samplingFrequency: HKQuantity?

    public let numberOfVoltageMeasurements: Int

    public let classification: HKElectrocardiogram.Classification

    public let averageHeartRate: HKQuantity?

    // MARK: HKSampleProtocol

    public let startDate: Date

    public let endDate: Date

    public var sampleType: HKSampleType {
        .electrocardiogramType()
    }

    // MARK: HKObjectProtocol

    public let uuid: UUID

    public let metadata: [String : Any]?

    public let device: HKDevice?
}
