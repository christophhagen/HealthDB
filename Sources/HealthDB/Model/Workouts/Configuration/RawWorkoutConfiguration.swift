import Foundation

struct RawWorkoutConfiguration: Codable {

    let version: Int

    let uuid: String

    let objectState: Int

    let strings: [String: String]

    let type: Int

    let objectModificationDate: Date

    let numbers: [String: Int]

    let data: Data
}
