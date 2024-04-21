import Foundation
import HealthKit

public struct HeartbeatSeries: HKSampleProtocol {

    public static let sampleType: SampleType = .other(.heartbeatSeries)

    /// The measured heart beats
    public let samples: [Sample]

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

    public init(samples: [Sample], startDate: Date, endDate: Date, uuid: UUID, metadata: [String : Any]?, device: HKDevice?) {
        self.samples = samples
        self.startDate = startDate
        self.endDate = endDate
        self.uuid = uuid
        self.metadata = metadata
        self.device = device
    }

    /// A single heart beat
    public struct Sample {

        /// The time of the heartbeat, measured from the series start date.
        public let timeSinceSeriesStart: TimeInterval

        /// A Boolean value that indicates whether this heartbeat was immediately preceded by a gap in the data, indicating that one or more heartbeats may be missing.
        public let isPrecededByGap: Bool
    }
}

extension HeartbeatSeries {

    static func samples(from data: Data) -> [Sample]? {
        guard data.count % 16 == 0 else {
            return nil
        }
        return stride(from: data.startIndex, to: data.endIndex, by: 16).map { index in
            let timestamp = data[index..<index+8].withUnsafeBytes { $0.bindMemory(to: Double.self).first! }
            let hasGap = data[index+8] > 0
            return Sample(timeSinceSeriesStart: timestamp, isPrecededByGap: hasGap)
        }
    }
}

extension HeartbeatSeries: BinarySample {

    static func from(object: ObjectData, data: Data) -> HeartbeatSeries? {
        guard let samples = HeartbeatSeries.samples(from: data) else {
            return nil
        }
        return .init(
            samples: samples,
            startDate: object.startDate,
            endDate: object.endDate,
            uuid: object.uuid,
            metadata: object.metadata.withoutUUID(),
            device: object.device)
    }
}
