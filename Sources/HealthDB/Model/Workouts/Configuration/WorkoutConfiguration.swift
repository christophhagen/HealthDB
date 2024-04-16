import Foundation

public struct WorkoutConfiguration {
    
    public let version: Int

    public let uuid: UUID

    public let objectState: Int

    public let strings: [String: String]

    public let type: Int

    public let objectModificationDate: Date

    public let numbers: [String: Int]

    public let data: ConfigurationData

    public var configurationType: Int? {
        numbers["configuration_type"]
    }

    public var goalType: Int? {
        numbers["goal_type"]
    }

    public var occurrenceCount: Int? {
        numbers["occurrence_count"]
    }

    /**
     Decode a workout configuration from data.

     The configuration is stored in the metadata of workouts using the ``HKPrivateMetadata.workoutConfiguration`` key.
     */
    public init(data: Data) throws {
        let decoder = JSONDecoder()
        let raw = try decoder.decode(RawWorkoutConfiguration.self, from: data)
        guard let uuid = UUID(uuidString: raw.uuid) else {
            throw HKNotSupportedError("Invalid UUID string \(raw.uuid) found in workout configuration")
        }
        self.version = raw.version
        self.uuid = uuid
        self.objectState = raw.objectState
        self.strings = raw.strings
        self.type = raw.type
        self.objectModificationDate = raw.objectModificationDate
        self.numbers = raw.numbers
        self.data = try .init(data: raw.data)
    }
}
