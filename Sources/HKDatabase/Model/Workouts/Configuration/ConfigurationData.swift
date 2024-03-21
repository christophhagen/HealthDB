import Foundation

extension WorkoutConfiguration {

    public struct ConfigurationData {

        public let goal: Goal?

        public let uuid: UUID

        public let type: Int

        public let activityType: ActivityType

        public let occurrence: Occurence

        init(data: Data) throws {
            let raw = try JSONDecoder().decode(RawConfigurationData.self, from: data)
            guard let uuid = UUID(uuidString: raw.uuid) else {
                throw HKNotSupportedError("Invalid UUID string \(raw.uuid) in workout configuration data")
            }
            self.uuid = uuid
            self.type = raw.type
            self.occurrence = raw.occurrence
            self.goal = try raw.goal.map { try.init(data: $0) }
            self.activityType = try .init(data: raw.activityType)
        }
    }
}
