import Foundation
import SQLite

struct SleepScheduleSamples {

    let table = Table("sleep_schedule_samples")

    let dataId = SQLite.Expression<Int>("data_id")

    let monday = SQLite.Expression<Int>("monday")

    let tuesday = SQLite.Expression<Int>("tuesday")

    let wednesday = SQLite.Expression<Int>("wednesday")

    let thursday = SQLite.Expression<Int>("thursday")

    let friday = SQLite.Expression<Int>("friday")

    let saturday = SQLite.Expression<Int>("saturday")

    let sunday = SQLite.Expression<Int>("sunday")

    let wakeHour = SQLite.Expression<Int?>("wake_hour")

    let wakeMinute = SQLite.Expression<Int?>("wake_minute")

    let bedHour = SQLite.Expression<Int?>("bed_hour")

    let bedMinute = SQLite.Expression<Int?>("bed_minute")

    let overrideDayIndex = SQLite.Expression<Int?>("override_day_index")

    func create(in database: Connection) throws {
        try database.execute("CREATE TABLE sleep_schedule_samples (data_id INTEGER PRIMARY KEY, monday INTEGER NOT NULL, tuesday INTEGER NOT NULL, wednesday INTEGER NOT NULL, thursday INTEGER NOT NULL, friday INTEGER NOT NULL, saturday INTEGER NOT NULL, sunday INTEGER NOT NULL, wake_hour INTEGER, wake_minute INTEGER, bed_hour INTEGER, bed_minute INTEGER, override_day_index INTEGER)")
    }

    func sleepSchedule(from row: Row) -> SleepSchedule? {
        let days: [Weekday] = [
            row[sunday],
            row[monday],
            row[tuesday],
            row[wednesday],
            row[thursday],
            row[friday],
            row[saturday]
        ].enumerated().compactMap { index, value in
            guard value > 0 else {
                return nil
            }
            return Weekday(rawValue: index)
        }
        guard !days.isEmpty else {
            return nil
        }

        var wakeTime: SleepSchedule.Time? = nil
        if let wakeHour = row[wakeHour], let wakeMinute = row[wakeMinute] {
            wakeTime = .init(hour: wakeHour, minute: wakeMinute)
        }
        var bedTime: SleepSchedule.Time? = nil
        if let bedHour = row[bedHour], let bedMinute = row[bedMinute] {
            bedTime = .init(hour: bedHour, minute: bedMinute)
        }

        return .init(
            relevantDays: Set(days),
            wakeTime: wakeTime,
            bedTime: bedTime,
            overrideDayIndex: row[overrideDayIndex])
    }
}
