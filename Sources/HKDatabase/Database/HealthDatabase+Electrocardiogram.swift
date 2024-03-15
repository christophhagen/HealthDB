import HealthKit
import HealthKitExtensions

extension HealthDatabase {
    
    // MARK: ECG Samples

    /**
     Read Electorcardiogram samples.
     - Parameter start: The start date of the interval to search
     - Parameter end: The end date of the interval to search
     - Returns: The samples in the specified date range
     */
    public func electrocardiograms(from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [Electrocardiogram] {
        try store.electrocardiograms(from: start, to: end)
    }

    /**
     Get the voltage measurements associated with an electrocardiogram.
     - Parameter electrocardiogram: The electrocardiogram for which to get voltage measurements
     - Returns: The voltage measurements in the electrocardiogram
     */
    public func voltageMeasurements(associatedWith electrocardiogram: Electrocardiogram) throws -> [HKQuantity] {
        try store.voltageMeasurements(associatedWith: electrocardiogram)
    }
}
