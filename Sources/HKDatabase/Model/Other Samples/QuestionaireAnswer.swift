import Foundation

/**
 The answer of a user to a question
 */
public enum QuestionaireAnswer: Int {

    case notAtAll = 0
    case severalDays = 1
    case moreThanHalfTheDays = 2
    case nearlyEveryDay = 3
}

extension QuestionaireAnswer: CustomStringConvertible {

    public var description: String {
        switch self {
        case .notAtAll:
            return "Not at all"
        case .severalDays:
            return "Several days"
        case .moreThanHalfTheDays:
            return "More than half the days"
        case .nearlyEveryDay:
            return "Nearly every day"
        }
    }
}
