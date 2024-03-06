import Foundation
import HealthKit

public struct HKNotSupportedError: Error {

    public let message: String

    public init(_ message: String) {
        self.message = message
    }
}

private struct InternalQuery {

    let sampleType: HKSampleType

    let predicate: NSPredicate?

    let limit: Int?

    let sortDescriptors: [NSSortDescriptor]?

    let resultsHandler: (HKSampleQuery, [HKSample]?, Error?) -> Void

    init(sampleType: HKSampleType, predicate: NSPredicate?, limit: Int, sortDescriptors: [NSSortDescriptor]?, resultsHandler: @escaping (HKSampleQuery, [HKSample]?, Error?) -> Void) {
        self.sampleType = sampleType
        self.predicate = predicate
        self.limit = limit == HKObjectQueryNoLimit ? nil : limit
        self.sortDescriptors = sortDescriptors
        self.resultsHandler = resultsHandler
    }

    var sampleQuery: HKSampleQuery {
        .init(sampleType: sampleType, predicate: predicate, limit: limit ?? HKObjectQueryNoLimit, sortDescriptors: sortDescriptors, resultsHandler: resultsHandler)
    }
}

extension HealthDatabase {

    public func executeSampleQuery(sampleType: HKSampleType, predicate: NSPredicate?, limit: Int, sortDescriptors: [NSSortDescriptor]?, resultsHandler: @escaping (HKSampleQuery, [HKSample]?, Error?) -> Void) -> HKQuery {
        let query = HKSampleQuery(
            sampleType: sampleType,
            predicate: predicate,
            limit: limit,
            sortDescriptors: sortDescriptors,
            resultsHandler: resultsHandler)

        let limit = limit == HKObjectQueryNoLimit ? nil : limit

        do {
            let result = try collectSamples(type: sampleType)
                .filtered(using: predicate)
                .sorted(using: sortDescriptors)
                .limit(limit)
            resultsHandler(query, result, nil)
        } catch {
            resultsHandler(query, nil, error)
        }
        return query
    }

    private func collectSamples(type: HKSampleType) throws  -> [HKSample] {
        switch type {
        case is HKWorkoutType:
            return try workoutSamples()
        case is HKCorrelationType:
            // TODO: Implement
            throw HKNotSupportedError("HKCorrelationType not supported")
        case is HKQuantityType:
            // TODO: Implement
            throw HKNotSupportedError("HKQuantityType not supported")
        case is HKAudiogramSampleType:
            // TODO: Implement
            throw HKNotSupportedError("HKAudiogramSampleType not supported")
        case is HKElectrocardiogramType:
            // TODO: Implement
            throw HKNotSupportedError("HKElectrocardiogramType not supported")
        case is HKPrescriptionType:
            // TODO: Implement
            throw HKNotSupportedError("HKPrescriptionType not supported")
        case is HKClinicalType:
            // TODO: Implement
            throw HKNotSupportedError("HKClinicalType not supported")
        case let categoryType as HKCategoryType:
            let type = HKCategoryTypeIdentifier(rawValue: categoryType.identifier)
            return try categorySamples(type: type)
        case is HKDocumentType:
            // TODO: Implement
            throw HKNotSupportedError("HKDocumentType not supported")
        case is HKSeriesType:
            // TODO: Implement
            throw HKNotSupportedError("HKSeriesType not supported")
        //case is HKCharacteristicType:
        //    break
        //case is HKActivitySummaryType:
        //    break
        default:
            throw HKNotSupportedError("Unknown sample type not supported")
        }
    }

    private func workoutSamples() throws -> [HKSample] {
        #warning("Get workouts and filter them")
        return []
    }
}

extension Array where Element: AnyObject {

    func limit(_ limit: Int?) -> [Element] {
        guard let limit else {
            return self
        }
        return Array(prefix(limit))
    }

    func sorted(using sortDescriptors: [NSSortDescriptor]?) -> [Element] {
        guard let sortDescriptors else {
            return self
        }
        return sorted {
            for sortDescriptor in sortDescriptors {
                switch sortDescriptor.compare($0, to: $1) {
                case .orderedAscending: return true
                case .orderedDescending: return false
                case .orderedSame: continue
                }
            }
            return false
        }
    }
}

extension Array where Element: AnyObject {

    public func filtered(using predicate: NSPredicate?) -> [Element] {
        guard let predicate else {
            return self
        }
        return (self as NSArray).filtered(using: predicate) as! [Element]
    }
}
