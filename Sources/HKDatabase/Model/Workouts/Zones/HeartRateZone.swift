import Foundation
import HealthKitExtensions

/**
 A heart rate zone of a workout.
 */
public struct HeartRateZone {

    /// The heart rate lower bound (unit BPM)
    let lowerBound: Int

    /// The heart rate upper bound (unit BPM)
    let upperBound: Int

    /// The time spent in the heart rate zone (seconds)
    let timeInZone: TimeInterval

    static func from(metadata: Metadata) throws -> [HeartRateZone] {
        guard let zoneData: Data = metadata.value(forPrivateKey: .workoutHeartRateZones) else {
            return []
        }
        let decoder = PropertyListDecoder()
        let zones = try decoder.decode([RawZone].self, from: zoneData)

        let times = try metadata.value(forPrivateKey: .workoutElapsedTimeInHeartRateZones).map {
            try decoder.decode([Int : Double].self, from: $0)
        } ?? [:]

        return try zones
            .sorted { $0.configurationIndex < $1.configurationIndex }
            .enumerated()
            .map { (offset, element) in
                guard offset == element.configurationIndex else {
                    throw HKNotSupportedError("Missing workout zone \(offset), found \(element.configurationIndex)")
                }
                return .init(
                    lowerBound: element.lowerDisplayBound,
                    upperBound: element.upperDisplayBound,
                    timeInZone: times[element.configurationIndex] ?? 0.0)
            }
    }
}

extension HeartRateZone: CustomStringConvertible {

    public var description: String {
        "Zone \(lowerBound)-\(upperBound): \(timeInZone.roundedInt) s"
    }
}
