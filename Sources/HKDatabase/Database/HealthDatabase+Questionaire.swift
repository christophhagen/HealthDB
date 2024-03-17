import Foundation

extension HealthDatabase {

    /**
     Get the user's answers to questionaires.

     - Note: This functionality is available for newer databases (iOS 17 and above
     */
    public func questionaires<T>(_ type: T.Type = T.self, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [T] where T: Questionaire {
        try store.questionaires(type, from: start, to: end)
    }
}
