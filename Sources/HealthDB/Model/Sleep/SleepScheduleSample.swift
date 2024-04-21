import Foundation
import HealthKit

public struct SleepScheduleSample: HKSampleProtocol {

    public static let sampleType: SampleType = .other(.sleepSchedule)

    public let sleepSchedule: SleepSchedule?

    // MARK: HKSampleProtocol

    public let startDate: Date

    public let endDate: Date

    public let uuid: UUID

    // MARK: HKObjectProtocol

    public let metadata: [String : Any]?

    public let device: HKDevice?

    public var sampleType: HKSampleType {
        fatalError()
    }

    public init(sleepSchedule: SleepSchedule?, startDate: Date, endDate: Date, uuid: UUID, metadata: [String : Any]?, device: HKDevice?) {
        self.sleepSchedule = sleepSchedule
        self.startDate = startDate
        self.endDate = endDate
        self.uuid = uuid
        self.metadata = metadata
        self.device = device
    }
}
