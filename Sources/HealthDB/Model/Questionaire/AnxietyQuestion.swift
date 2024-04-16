import Foundation

/**
 A question asked during an anxiety questionaire.
 */
public enum AnxietyRiskQuestion: Int {

    /// Nervousness
    ///
    /// Feeling nervous, anxious or on edge
    case nervous = 0

    /// Worrying a lot
    ///
    /// Not being able to stop or control worrying
    case continuousWorrying = 1

    /// Worrying about a lot
    ///
    /// Worrying too much about different things
    case worryingAboutDifferentThings = 2

    /// Relaxing issues
    ///
    /// Trouble relaxing
    case relaxing = 3

    /// Restlessness
    ///
    /// Being so restless that it is hard to sit still
    case restlessness = 4

    /// Irritability
    ///
    /// Becoming easily annoyed or irritable
    case irritability = 5

    /// Afraid of negative experiences
    ///
    /// Feeling afraid as if something awful might happen
    case afraid = 6
}

extension AnxietyRiskQuestion: CustomStringConvertible {

    public var description: String {
        switch self {
        case .nervous:
            return "Feeling nervous, anxious or on edge"
        case .continuousWorrying:
            return "Not being able to stop or control worrying"
        case .worryingAboutDifferentThings:
            return "Worrying too much about different things"
        case .relaxing:
            return "Trouble relaxing"
        case .restlessness:
            return "Being so restless that it is hard to sit still"
        case .irritability:
            return "Becoming easily annoyed or irritable"
        case .afraid:
            return "Feeling afraid as if something awful might happen"
        }
    }
}
