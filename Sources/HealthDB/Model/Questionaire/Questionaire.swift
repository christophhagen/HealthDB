import Foundation
import HealthKit

public protocol Questionaire: HKSampleProtocol {

    associatedtype Question: RawRepresentable where Question.RawValue == Int

    static var otherSampleType: SampleType.Other { get }

    var score: Int { get }

    var risk: Risk { get }

    var answers: [Int] { get }

    init(score: Int, risk: Risk, answers: [Int], startDate: Date, endDate: Date, uuid: UUID, metadata: [String : Any]?, device: HKDevice?)
}

extension Questionaire {

    static var sampleType: SampleType {
        .other(otherSampleType)
    }

    public func answer(to question: Question) -> QuestionaireAnswer? {
        let index = question.rawValue
        guard index < answers.count else {
            return nil
        }
        return .init(rawValue: answers[index])!
    }
}
