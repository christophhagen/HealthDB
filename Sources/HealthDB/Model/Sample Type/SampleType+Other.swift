import Foundation

extension SampleType {
    /**
     A collection of sample types which are not further grouped.
     */
    public enum Other: Int, CaseIterable {
        case weeklyCalorieGoal = 67
        case workoutActivity = 76
        case workout = 79
        case workoutRoute = 102
        case standHourGoal = 104
        case exerciseMinutesGoal = 105
        case appleWatchIsCharging = 116
        case heartbeatSeries = 119
        case ecgSample = 144
        case audiogram = 145
        case sleepSchedule = 198
        case anxietyRiskQuestionaire = 287
        case depressionRiskQuestionaire = 288
    }

}
extension SampleType.Other {

    var sampleType: SampleType {
        .other(self)
    }
}

extension SampleType.Other: CustomStringConvertible {

    public var description: String {
        switch self {
        case .weeklyCalorieGoal: return "Weekly Calorie Goal"
        case .workoutActivity: return "Workout Activity"
        case .workout: return "Workout"
        case .workoutRoute: return "Workout Route"
        case .standHourGoal: return "Stand Hour Goal"
        case .exerciseMinutesGoal: return "Exercise Minutes Goal"
        case .appleWatchIsCharging: return "Apple Watch Charging"
        case .heartbeatSeries: return "Heartbeat Series"
        case .ecgSample: return "ECG Sample"
        case .audiogram: return "Audiogram"
        case .sleepSchedule: return "Sleep Schedule Sample"
        case .anxietyRiskQuestionaire: return "Anxiety Risk Questionaire"
        case .depressionRiskQuestionaire: return "Depression Risk Questionaire"
        }
    }
}
