import Foundation

/**
 A workout heart rate zone.

 This type is used to decode the binary data associated with `HKPrivateMetadataKey.workoutHeartRateZones` metadata keys using a `PropertyListDecoder`.
 */
struct RawZone: Codable {

    let configurationCount: Int

    let configurationIndex: Int

    let lowerDisplayBound: Int

    let upperDisplayBound: Int
}
