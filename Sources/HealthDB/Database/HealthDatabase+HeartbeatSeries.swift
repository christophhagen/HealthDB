import Foundation

extension HealthDatabase {

    public func heartBeatSeries(from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [HeartbeatSeries] {
        try store.heartBeatSeries(from: start, to: end)
    }
}
