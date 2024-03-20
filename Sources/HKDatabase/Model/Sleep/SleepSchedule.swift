import Foundation

public struct SleepSchedule {

    public struct Time {
        let hour: Int
        let minute: Int
    }

    public let relevantDays: Set<Weekday>

    public let wakeTime: Time?

    public let bedTime: Time?

    public let overrideDayIndex: Int?
}

