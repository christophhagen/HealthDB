import Foundation

/**
 A question asked during a depression risk questionaire.
 */
public enum DepressionRiskQuestion: Int {

    /// Interests
    ///
    /// Little interest or pleasure in doing things
    case littleInterests = 0

    /// Negative feelings
    ///
    /// Feeling down, depressed or hopeless
    case feelingDown = 1

    /// Sleep
    ///
    /// Trouble or staying asleep, or sleeping too much
    case sleepProblems = 2

    /// Energy
    ///
    /// Feeling tired of having little energy
    case tiredness = 3

    /// Appetite
    ///
    /// Poor appetite or overeating
    case poorAppetite = 4

    /// Self image
    ///
    /// Feeling bad about yourself - or that you are a failure or have let yourself or your family down
    case feelingBad = 5

    /// Concentration
    ///
    /// Trouble concentrating on things, such as reading the newspaper or watching television
    case troubleConcentrating = 6

    /// Speaking
    ///
    /// Moving or speaking so slowly that other people have noticed? Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual
    case speaking = 7

    /// Self-harm
    ///
    /// Thoughts that you would be better off dead or of hurting yourself in some way
    case suicideThoughts = 8
}

extension DepressionRiskQuestion: CustomStringConvertible {

    public var description: String {
        switch self {
        case .littleInterests:
            return "Little interest or pleasure in doing things"
        case .feelingDown:
            return "Feeling down, depressed or hopeless"
        case .sleepProblems:
            return "Trouble or staying asleep, or sleeping too much"
        case .tiredness:
            return "Feeling tired of having little energy"
        case .poorAppetite:
            return "Poor appetite or overeating"
        case .feelingBad:
            return "Feeling bad about yourself - or that you are a failure or have let yourself or your family down"
        case .troubleConcentrating:
            return "Trouble concentrating on things, such as reading the newspaper or watching television"
        case .speaking:
            return "Moving or speaking so slowly that other people have noticed? Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual"
        case .suicideThoughts:
            return "Thoughts that you would be better off dead or of hurting yourself in some way"
        }
    }
}
