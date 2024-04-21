import Foundation
import HealthKit

/**
 The results of an anxiety risk questionaire
 */
public struct AnxietyRiskQuestionaire: Questionaire {

    public typealias Question = AnxietyRiskQuestion

    public static let otherSampleType: SampleType.Other = .anxietyRiskQuestionaire

    public let score: Int

    public let risk: Risk

    public let answers: [Int]

    // MARK: HKSampleProtocol

    public let startDate: Date

    public let endDate: Date

    public let uuid: UUID

    // MARK: HKObjectProtocol

    public let metadata: [String : Any]?

    public let device: HKDevice?

    public var sampleType: HKSampleType {
        fatalError()
    }

    // MARK: Questionaire

    public init(score: Int, risk: Risk, answers: [Int], startDate: Date, endDate: Date, uuid: UUID, metadata: [String : Any]?, device: HKDevice?) {
        self.score = score
        self.risk = risk
        self.answers = answers
        self.startDate = startDate
        self.endDate = endDate
        self.uuid = uuid
        self.metadata = metadata
        self.device = device
    }
}
