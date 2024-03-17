import HealthKit
import HealthKitExtensions

extension HealthDatabase {
    
    /**
     Access category samples in a date interval.
     - Parameter type: The category sample type
     - Parameter start: The beginning of the date range of interest
     - Parameter end: The end of the date range
     */
    public func samples<T>(ofType type: T.Type = T.self, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [T] where T: HKCategorySampleContainer {
        try store.samples(category: T.categoryTypeIdentifier, from: start, to: end)
            .map { T.init(categorySample: $0) }
    }

    /**
     Access category samples in a date interval.
     - Parameter type: The category sample type
     - Parameter predicate: The predicate to filter the samples
     - Parameter sortDescriptors: The descriptors to order the returned samples
     - Parameter limit: The maximum number of samples to return
     */
    public func samples<T>(ofCategory category: T.Type = T.self, predicate: NSPredicate? = nil, sortDescriptors: [SortDescriptor<HKCategorySample>] = [], limit: Int? = nil) throws -> [T] where T : HKCategorySampleContainer {
        try store.samples(category: T.categoryTypeIdentifier)
            .filtered(using: predicate)
            .sorted(using: sortDescriptors)
            .limited(by: limit)
            .map(T.init(categorySample:))
    }

    /**
     Access quantity samples in a date interval.
     - Parameter type: The quantity sample type
     - Parameter start: The beginning of the date range of interest
     - Parameter end: The end of the date range
     */
    public func samples<T>(ofQuantity quantity: T.Type = T.self, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [T] where T: HKQuantitySampleContainer {
        try store.samples(
            quantity: T.quantityTypeIdentifier,
            includingSeriesData: false,
            from: start, to: end,
            unit: T.defaultUnit)
        .map { T.init(quantitySample: $0) }
    }

    /**
     Access quantity samples in a date interval.
     - Parameter type: The quantity sample type
     - Parameter includingSeriesData: Include samples from data series
     - Parameter start: The beginning of the date range of interest
     - Parameter end: The end of the date range
     */
    public func samples<T>(ofQuantity quantity: T.Type = T.self, includingSeriesData: Bool, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [T] where T: HKQuantitySampleContainer {
        try store.samples(
            quantity: T.quantityTypeIdentifier,
            includingSeriesData: includingSeriesData,
            from: start, to: end,
            unit: T.defaultUnit)
        .map { T.init(quantitySample: $0) }
    }

    public func samples<T>(ofQuantity quantity: T.Type = T.self, predicate: NSPredicate?, sortDescriptors: [SortDescriptor<HKQuantitySample>], limit: Int?) throws -> [T] where T : HKQuantitySampleContainer {

        try store.samples(quantity: T.quantityTypeIdentifier)
            .filtered(using: predicate)
            .sorted(using: sortDescriptors)
            .limited(by: limit)
            .map(T.init(quantitySample:))
    }

    // MARK: Correlations

    public func correlations<T>(_ correlation: T.Type = T.self, predicate: NSPredicate?, sortDescriptors: [SortDescriptor<HKCorrelation>], limit: Int?) throws -> [T] where T : HKCorrelationContainer {
        try store.correlations(T.correlationTypeIdentifier)
            .filtered(using: predicate)
            .sorted(using: sortDescriptors)
            .limited(by: limit)
            .map(T.init(correlation:))
    }

    /**
     Access correlations in a date interval.
     - Parameter type: The correlation type
     - Parameter start: The beginning of the date range of interest
     - Parameter end: The end of the date range
     */
    public func correlations<T>(_ correlation: T.Type = T.self, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [T] where T: HKCorrelationContainer {
        try store.correlations(T.correlationTypeIdentifier, from: start, to: end)
        .map { T.init(correlation: $0) }
    }

}
