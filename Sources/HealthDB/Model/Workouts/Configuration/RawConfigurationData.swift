import Foundation

struct RawConfigurationData: Codable {

    let goal: Data?

    let uuid: String

    let type: Int

    let activityType: Data

    let occurrence: WorkoutConfiguration.Occurence
}
