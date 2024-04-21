import Foundation
import HealthKit

/**
 A sample type.

 The sample type identifies what type of data a sample contains.

 In the SQLite database, it is stored as an integer.
 */
public enum SampleType {

    /// A category sample type
    case category(HKCategoryTypeIdentifier)

    /// A quantity sample type
    case quantity(HKQuantityTypeIdentifier)

    /// A correlation type
    case correlation(HKCorrelationTypeIdentifier)

    /// One of the other known sample types
    case other(Other)

    /// An unknown sample type
    case unknown(Int)
}

extension SampleType: Equatable {

}

extension SampleType: Hashable {

}

extension SampleType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .category(let hKCategoryTypeIdentifier):
            return hKCategoryTypeIdentifier.description
        case .quantity(let hKQuantityTypeIdentifier):
            return hKQuantityTypeIdentifier.description
        case .correlation(let hKCorrelationTypeIdentifier):
            return hKCorrelationTypeIdentifier.description
        case .other(let otherSampleType):
            return otherSampleType.description
        case .unknown(let int):
            return "Unknown sample type (\(int))"
        }
    }
}

extension SampleType: CaseIterable {
    public static var allCases: [SampleType] {
        var all = [SampleType]()
        all.append(contentsOf: HKCategoryTypeIdentifier.allCases.map { $0.sampleType })
        all.append(contentsOf: HKQuantityTypeIdentifier.allCases.map { $0.sampleType })
        all.append(contentsOf: HKCorrelationTypeIdentifier.allCases.map { $0.sampleType })
        all.append(contentsOf: SampleType.Other.allCases.map { $0.sampleType })
        return all
    }
}

extension SampleType {

    public init(rawValue: Int) {
        if let category = HKCategoryTypeIdentifier.map[value: rawValue] {
            self = .category(category)
        } else if let quantity = HKQuantityTypeIdentifier.map[value: rawValue] {
            self = .quantity(quantity)
        } else if let correlation = HKCorrelationTypeIdentifier.map[value: rawValue] {
            self = .correlation(correlation)
        } else if let value = SampleType.Other(rawValue: rawValue) {
            self = .other(value)
        } else {
            self = .unknown(rawValue)
        }
    }

    public var rawValue: Int? {
        switch self {
        case .category(let hKCategoryTypeIdentifier):
            return hKCategoryTypeIdentifier.intValue
        case .quantity(let hKQuantityTypeIdentifier):
            return hKQuantityTypeIdentifier.intValue
        case .correlation(let hKCorrelationTypeIdentifier):
            return hKCorrelationTypeIdentifier.intValue
        case .other(let other):
            return other.rawValue
        case .unknown(let int):
            return int
        }
    }
}
