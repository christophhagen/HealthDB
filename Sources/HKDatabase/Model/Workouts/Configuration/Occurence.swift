import Foundation

extension WorkoutConfiguration {
    
    public struct Occurence {

        public let creationDate: Date

        public let count: Int

        public let modificationDate: Date

        public let countModificationDate: Date
    }
}

extension WorkoutConfiguration.Occurence: Codable {

}
