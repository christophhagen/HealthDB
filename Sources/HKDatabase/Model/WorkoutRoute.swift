import Foundation
import HealthKit

/**
 A workout route loaded from the database.
 */
public struct WorkoutRoute: HKSampleProtocol {

    /**
     The id of the sample.

     Identifies the sample and links it to various other tables.
     */
    public let dataId: Int

    /// Unknown property. Seems to always be `1`.
    public let isFrozen: Int

    /// The number of samples in the route
    public let count: Int
    /**
     Unknown property.

     Seems to be a timestamp close to the start of the first sample (within one day).
     */
    public let insertionEra: Int

    /// The key to locate location samples in the `location_series_data` table.
    public let hfdKey: Int

    /// Unknown property. Seems to always be `2`.
    public let seriesLocation: Int

    // MARK: HKSampleProtocol

    public let startDate: Date

    public let endDate: Date

    public var sampleType: HKSampleType {
        HKSeriesType.workoutRoute()
    }

    // MARK: HKObjectProtocol

    public let uuid: UUID

    public let device: HKDevice?

    public let metadata: [String : Any]?

}
