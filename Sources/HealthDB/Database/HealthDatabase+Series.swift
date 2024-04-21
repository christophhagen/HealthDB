import HealthKit
import HealthKitExtensions

extension HealthDatabase {
    
    /**
     Query quantity series overlapping a date interval.
     */
    public func series<T>(ofQuantity quantity: T.Type = T.self, from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [QuantitySeries<T>] where T: HKQuantitySampleContainer {
        try store.series(quantity: T.quantityTypeIdentifier, unit: T.defaultUnit, from: start, to: end)
            .map { .init(
                dataId: $0.dataId,
                sampleCount: $0.sampleCount,
                insertionEra: $0.insertionEra,
                hfdKey: $0.hfdKey,
                seriesLocation: $0.seriesLocation,
                sample: T.init(quantitySample: $0.sample))
            }
    }

    /**
     Get the quantities associated with a quantity series.

     The returned samples all have the same data type as the original series sample, and include the same `device` and `metadata`.
     */
    public func quantities<T>(in series: QuantitySeries<T>) throws -> [T] {
        try store.quantities(in: series)
            .map(T.init(quantitySample:))
    }

    // MARK: Heartbeat Series

    /**
     Query for heartbeat series samples within a date interval.
     */
    public func heartBeatSeries(from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [HeartbeatSeries] {
        try store.heartBeatSeries(from: start, to: end)
    }

    // MARK: Audiograms

    /**
     Query for audiogram samples within a date interval.
     */
    public func audiograms(from start: Date = .distantPast, to end: Date = .distantFuture) throws -> [HKAudiogramSample] {
        try store.audiograms(from: start, to: end)
    }
}
