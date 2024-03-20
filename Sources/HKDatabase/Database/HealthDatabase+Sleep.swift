import Foundation


extension HealthDatabase {

    public func sleepSchedules(from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [SleepScheduleSample] {
        try store.sleepSchedules(from: start, to: end)
    }
}
