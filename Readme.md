# iOS Health Database Interface

A Swift interface to access health records of `healthdb_secure.sqlite` files which have been recovered from iOS backups.

This library is a reverse-engineering effort to reconstruct Health data from the SQLite database contained in an iOS Backup.
This library may can be useful when the original health data is lost and has to be recovered, or when a sample database is needed for testing.
And in general, it can be quite interesting to see the amount of data stored in Health.

## Working features

The framework allows access to a large part of the health records, but not all data types are fully supported.
New features may be added in the future, but there is also a chance that future updates may change the database layout and break a few things.

The following feature list refers to databases recovered with iOS 16 and iOS 17.

| Feature | Status | Comment |
|---|---|---|
[Category samples](#category-samples) | ✅ | 59/65 types supported |
[Quantity samples](#quantity-samples) | ✅ | 109/112 types supported |
[Quantity series](#quantity-sample-series) | ✅ | 109/112 types supported |
[Workouts](#workouts) | ✅ 
[Workout activities](#workouts) | ✅ 
[Workout events](#workouts) | ✅ 
[Workout statistics](#workouts) | ✅ | Average + min/max
Workout goals | ✅ | Duration, Distance, Calories
[Workout zones](#workout-heart-rate-zones) | ✅
[User characteristics](#basic-user-characteristics-and-values) | ✅ | Except `HKActivityMoveMode`
[Correlations](#correlation-samples) | ✅ |
[ECG Samples](#ecg-samples) | ✅ | Including voltages
[Scored Assessments](#scored-assessments) | ✅ | Since iOS 17
[Sleep schedules](#sleep-schedules) | ✅
[HeartbeatSeries](#heartbeat-series) | ✅
Medical records and prescriptions | ❌
Achievements | ❌
Audiogram samples | ❌

### Caveats

Unfortunately, Apple makes it very difficult to work with Health Data outside the provided framework. 
Most problematically, a lot of `HealthKit` types don't expose properties publicly that would be needed/useful. 
For example, it's not possible to construct a full `HKWorkout` outside of the provided `HKHealthStore` (which is why this library uses it's own `Workout` type).

Secondly, the layout of internal data structures for the SQLite database are not publicly documented, so working with the database is based on guesswork and experiments. 
To understand all data formats, it's necessary to observe how data is stored in the individual tables, but some of the data can't be inserted through the publicly available API. 
For example, `EnvironmentalAudioExposureEvent`s can only be logged by an Apple Watch. 
Since sample types internally use integer IDs, it's difficult to figure out all assignments.
This framework can therefore not handle all sample types properly.

Another (minor) problem are the database columns with encoded binary data, where again, no information about the structure is available. 
There is currently some information not accessible and understood by this library.

## Opening a database

Extract the `healthdb_secure.sqlite` file from a device.
This is most easily done by creating a local (encrypted!) device backup, and the browsing the data with a tool like [iMazing](https://imazing.com).
The file should be placed in a location with read/write access.

```swift
import HKDatabase

let db = try HKDatabaseStore(fileUrl: ...)
```

The `HKDatabaseStore` is the basic object to interact with the health data, similar to the `HKHealthStore`.

This library relies heavily on the [HealthKitExtensions](https://github.com/christophhagen/HealthKitExtensions) to simplify interacting with health data, and provides a more convenient database wrapper:

```swift
let db = try HKDatabaseStoreWrapper(fileUrl: ...)
```

This class wraps a `HKDatabaseStore` and provides functions to more easily query the database.
The following readme is mostly based on this class.

## Basic user characteristics and values

Similar to the `HKHealthStore`, these can be accessed through separate functions on `HKDatabaseStoreWrapper`:

```swift
let sex = try db.biologicalSex()
let bloodType = try db.bloodType()
let dateOfBirth = try db.dateOfBirthComponents()
let skinType = try db.fitzpatrickSkinType()
let wheelchair = try db.wheelchairUse()
```

Access all values in the table through:

```swift
let data: [KeyValueEntry] = try db.keyValuePairs()
```

Internally, they are stored in the `key_value_secure` table.

## Samples

Samples are separated into different types, similar to the `HealthKit` types `HKCategorySample`, `HKQuantitySample`, `HKCorrelationSample`, etc.

**Note** All samples returned from the database have their original `UUID` set as a metadata property using the `HKMetadataKeyExternalUUID`. Original metadata with the same key is discarded.

In the database, the initial entry point is always the `samples` table. It contains the date interval and the data type.
This type then determines where the additional data is stored.

The known sample types are managed in the `SampleType` enum, as well as extensions on `HKQuantityTypeIdentifier`, `HKCorrelationTypeIdentifier`, and `HKCategoryTypeIdentifier`.

### Category samples

Access category samples through:

```swift
let samples: [Vomiting] = try db.samples(from: .distantPast, to: .now)
```

The functions will fail with a `HKNotSupportedError` if the internal `SampleType` identifier is not known.

The following category types are yet unsupported:

`HighHeartRateEvent`, `IrregularHeartRhythmEvent`, `LowCardioFitnessEvent`, `AppleWalkingSteadinessEvent`, `InfrequentMenstrualCycles`, `HeadphoneAudioExposureEvent`.

You can get a list of all unknown data types using:

```swift
let rawTypes = try db.store.unknownRawSampleTypes()
```

To access unknown samples if you know the corresponding HealthKit type:

```swift
let samples = try db.store.samples(
    rawCategory: 147, 
    as: .lowHeartRateEvent, 
    from: .distantPast, 
    to: .now)
```

This function will produce errors if the sample data contains invalid values, which may happen when the `SampleType` doesn't match the `HKCategoryTypeIdentifier`.

It's also possible to get the raw categories from the samples:

```swift
let samples = try db.store.categories(rawType: 147)
```

**Note** If you figure out the identifier for a currently unknown type, please open an issue, and it will be included.

Internally, the additional data of the samples is stored in the `category_samples` table where `samples.data_id == category_samples.data_id`

### Quantity samples

```swift
let samples: [BodyMass] = try db.samples(from: .distantPast, to: .now)
```

The functions will fail with a `HKNotSupportedError` if the internal `SampleType` identifier is not known.
The value in the database is interpreted according to the default unit of each sample type.

**Note** The database may contain quantity samples without an associated value (no entry in `quantity_samples`). These appear to be left over from past database migrations, since the samples are usually found as part of a [quantity series](#quantity-sample-series).
These samples are therefore skipped.

The following types are currently unsupported: `AppleSleepingWristTemperature`, `AppleMoveTime`, `NikeFuel`

To access unknown samples:

```swift
let samples = try db.samples(
        rawQuantity: 3, 
        as: .bodyMass, 
        unit: .gramUnit(with: .kilo), 
        from: .distantPast, 
        to: .now)
```

Similar to category samples, it's also possible to get the raw values:

```swift
let samples = try db.quantities(rawType: 3)
```

Internally, the additional data of the samples is stored in the `quantity_samples` table where `samples.data_id == quantity_samples.data_id`.
The database also stores an "original unit" for some samples, but this data is not exported.
The unit is contained in the `unit_string` column of the `unit_strings` table where `quantity_samples.original_unit == unit_strings.ROWID`.

### Correlation samples

```swift
let samples: [BloodPressure] = try db.correlations(from: .distantPast, to: .now)
```

The samples associated with a correlation (like blood pressure values) are also stored in the `samples` table.
They are connected with another sample (`data_type == 80` for blood pressure) through the `associations` table, which contains one entry per associated sample, where `sample.data_id == associations.parent_id` for the main sample, and `sample.data_id == associations.child_id` for the associated samples.

### Private samples

There are a few sample types that are normally not available through HealthKit, but still contained in the database.
These samples can be accessed by directly querying a sample type:

```swift
let samples = try db.store.categories(.appleWatchIsCharging)
let samples = try db.store.quantities(.exerciseMinutesGoal)
```

There are only a few of those private sample types currently known:

- `.appleWatchIsCharging`: Indicates when an Apple Watch is charging (`1`) or not (`0`).
- `.exerciseMinutesGoal`: A quantity sample for each time the exercise goal is changed (value = new goal)
- `.standHourGoal`: A quantity sample for each time the stand goal is changed (value = new goal)
- `.raw68`: Unknown category sample
- `.raw112`: Unknown category sample
- `.raw197`: Unknown quantity sample

### Scored assessments

Additionally, Health features (as of iOS 17?) questionaires about anxiety and depression, which can also be accessed:

```swift
let samples: [DepressionRiskQuestionaire] = try db.questionaires()
let answer = questionaire.answer(to: .suicideThoughts)
```
  
### Unhandled samples

There are many sample tables in the database, and all appear to be linked by their `data_id` column to the `data_id` column in the `samples` table.

| Name | Supported |
|---|---|
`account_owner_samples` | ❌
`allergy_record_samples` | ❌
`binary_samples` | ✅ (Heartbeat series, audiograms)
`category_samples` | ✅
`clinical_note_record_samples` | ❌
`clinical_record_samples` | ❌
`condition_record_samples` | ❌
`coverage_record_samples` | ❌
`diagnostic_test_report_samples` | ❌
`diagnostic_test_result_samples` | ❌
`ecg_samples` | ✅
`medication_dispense_record_samples` | ❌
`medication_dose_event_samples` | ❌
`medication_order_samples` | ❌
`medication_record_samples` | ❌
`procedure_record_samples` | ❌
`quantity_samples` | ✅
`scored_assessment_samples` | ✅
`signed_clinical_data_record_samples` | ❌
`sleep_schedule_samples` | ✅
`state_of_mind_samples` | ❌
`unknown_record_samples` | ❌
`vaccination_record_samples` | ❌
`verifiable_clinical_record_samples` | ❌
`workout_zones_samples` | ❌

### Quantity sample series

Some quantity samples are arranged in data series, which are associated with a specific sample.
This concerns mostly workout data, like heart rate, cycling power, or vertical oscillation data.

```swift
let heartRateSeries = try db.series(
    ofQuantity: HeartRate.self, 
    from: .distantPast, 
    to: .now)
let series = heartRateSeries.first!
let samples: [HeartRate] = try db.quantities(in: series)
```

**Note** The samples of the series have no `device` or `metadata` associated with it.
Check the `sample` property of the data series to get those values.

There are also functions on `HKDatabaseStore` to get simple `HKQuantitySample`s, and the possibility to manually select the raw sample type for unsupported quantity types.

If you don't care about the series and just want all samples of a specific type, you can request the samples directly:

```swift
let samples: [HeartRate] = try db.samples(
    includingSeriesData: true, 
    from: start, 
    to: end)
```

**Note**: If you select samples directly, then the `device` and `metadata` properties of the `HKQuantitySample`s will be set to the value of the data series sample.

Each data series contains an entry in `samples`, with the `data_type` according to the sample type.
An entry in the `quantity_sample_series` with the same `data_id` as the sample contains the series specification, including the number of samples.

The actual values of the data series are contained in `quantity_series_data`, where `quantity_sample_series.hfd_key == quantity_series_data.series_identifier`.
The `value` is scaled in the default unit of the sample type.

It's not obvious from the entry in `samples`, if a data series is linked to it.

For each data series, there is also an entry in `quantity_sample_statistics` where the `owner_id == samples.data_id`.

### Heartbeat Series

Samples about `Heart Rate Variability` are usually associated with a heartbeat series, which contains beat-by-beat measurements over a longer timespan.
These series can be queried by using:

```swift
let series: [HeartbeatSeries] = try db.heartbeatSeries(from: start, to: end)
```

Each series consists of the usual sample information (`start` and `end` date, UUID, device, ...) as well as an array of heart beat samples, which consist of a time interval indicating the offset to the start of the measurement, as well an indicator to show whether there may have been missed heartbeats before this one.
This structure is similar to [HKHeartbeatSeriesQuery](https://developer.apple.com/documentation/healthkit/hkheartbeatseriesquery/3113764-init).

The heartbeat data is stored in the `binary_samples` table, linked to an entry in the `samples` table through the `associations` table, where `samples.data_id == associations.child_id` and `associations.parent_id == binary_samples.data_id`.

The data in the `payload` column is organized in 16-byte chunks, where the first 8 bytes are a double indicating the `timeSinceSeriesStart` property. 
The 9th byte seems to indicate the `isPrecededByGap` property.
The meaning of the last seven bytes is currently unknown.
Most of these values are zeroes, but occasionally there are values like `0xa770270`, `0x57ef26`, `0xd7ab25`, `0xd65b15`, or `0x573e26`.
These values have no apparent meaning, and can occur with both `true` or `false` for `isPrecededByGap`.

### Audiograms

Stored `HKAudiogramSample`s can also be queried.

```swift
let samples: [HKAudiogramSample] = try db.audiograms(from: start, to: end)
```

Like heartbeat series data, the binary data associated with each sample is stored in `binary_samples`.
The `payload` column consists of an array of `HKAudiogramSensitivityPoint`s, encoded with an `NSKeyedArchiver`.

### Workouts

Workouts can be queried from the database similar to other samples:

```swift
let workouts = try db.workouts(from: .distantPast, to: .now)
let runs = try db.workouts(type: .running)
```

`HealthKit` doesn't allow the creation of `HKWorkout`s outside of the `HKHealthStore`, so this framework uses it's own `Workout` type.
The workouts have mostly similar fields, including the associated `workoutActivities` and `workoutEvents`.
Statistics are not yet included.

Workouts are entries in the `samples` table with `data_type == 79`. 
There is a matching entry in `workouts` with `samples.data_id == workouts.data_id`.

Workout activities are contained in `workout_activities` where `workouts.data_id == workout_activities.owner_id`.
Similarly, workout events are contained in `workout_events` where `workouts.data_id == workout_events.owner_id`.

Workout routes are entries in the `data_series` table.

### Workout routes

Workout routes are just location series and are linked to workouts.
As with workouts, this library uses it's own `WorkoutRoute` type, with similar fields to an `HKWorkoutRoute`.

```swift
let workout: Workout = ...
if let route = try db.route(associatedWith: workout) {
    let locations = try db.locations(associatedWith: route)
}
```

Data series are partially stored in the table `data_series`, but they also contain a sample in the `samples` table with `data_type == 102` and the same `data_id`.
The `data_series` table seems to currently only contain location series.

The column `hfd_key` links the data series to entries in the table `location_series_data` where `data_series.hfd_key == location_series_data.series_identifier`.

### Samples associated with workouts

You can request additional samples associated with a workout:

```swift
let workout: Workout = ...
let heartRateSamples = try db.samples(ofType: HeartRate.self, associatedWith: workout)
```

Both category and quantity samples can be requested.

### Workout statistics

The database stores some statistics about workout activities in a separate table.

```swift
let workout: Workout = ...
let activity = workout.workoutActivities.first!
let statistics = try db.statistics(associatedWith: activity)
let speed = statistics[.init(.runningSpeed)]
```

The resulting `Statistics` types are similar to `HKStatistics`, but with fewer properties (just `average`, `minimum` and `maximum`).
Presumably HealthKit computes the other properties on the fly.

It's also possible to get statistics of a specific type:

```swift
let workout: Workout = ...
let activity = workout.workoutActivities.first!
let speed = try db.statistics(for: RunningSpeed.self, associatedWith: activity)
print(speed!.average)
```

Or, even quicker:

```swift
let minSpeed = try db.minimum(for: RunningSpeed.self, associatedWith: activity)
```

Statistics are stored in the `workout_statistics` table.
They are linked to workout activities by `workout_activities.ROWID == workout_statistics.workout_activity_id`.

### Workout heart rate zones

Health stores heart rate zone data for workouts.
This data contains the configured heart rate intervals for the zones, as well as the time spent in them.

```swift
let zoneData = try db.heartRateZones(associatedWith: workout)
print(zoneData.zones[0].lowerBound) // BPM
print(zoneData.times[0]) // Time in seconds
```

The data is stored in binary format in two private metadata fields `HKPrivateMetadataKey.workoutHeartRateZones` and `HKPrivateMetadataKey.workoutElapsedTimeInHeartRateZones`.
The first can be decoded as an array of `RawZone` objects containing upper and lower heart rate bounds using a `PropertyListDecoder`.
The second is also a property list, containing a dictionairy of integer keys and double values, representing the duration associated with each zone index.
There are additional private metadata fields apparently assocaited with workout zones, but their use is currently unknown:
- `HKPrivateMetadataKey.workoutHeartRateZonesConfigurationType`: Int
- `HKPrivateMetadataKey.workoutHeartRateZonesCurrentZoneIndex`: Int
- `HKPrivateMetadataKey.workoutHeartRateZonesLastProcessedEntryDate`: Date
- `HKPrivateMetadataKey.workoutHeartRateZonesLastProcessedEventDate`: Date

### Workout configuration

Health stores configuration data as metadata with every workout, which can be accessed:

```swift
let config = try db.configuration(associatedWith: workout)
```

It's not fully clear what each property of the configuration represents, since the format has been reconstructed from a private field where no documentation exists.
Apple may change the data structures at any time, so this feature may or may not work for you.

Workout configuration is stored as metadata on `HKWorkout` samples using the key `HKMetadataPrivateKey.workoutConfiguration` (raw value `_HKPrivateWorkoutConfiguration`).
The configuration is stored as binary data, which can be decoded as `JSON` (using the internal type `RawWorkoutConfiguration`).
This struct contains a few values, and another `data` field, which again contains a JSON payload.
Decoding this data using `RawConfigurationData` yields more properties and two more binary fields (`goal` and `activityType`).
Both of these are encoded using `NSKeyedArchiver`, and the underlying encoded classes are unknown.
They are internally reconstructed based on available samples as `NLSessionActivityGoal` and `FIUIWorkoutActivityType`.
All of that data is then combined into a public type for convenience.

### Converting workouts

It's possible to insert `Workout`s into a proper `HKHealthStore`:

```swift
let heartRateSamples: [HKSample] = ...
let routePoints: [CLLocation] = ...
let savedWorkout: HKWorkout = try workout.insert(
    into: HKHealthStore(), 
    samples: heartRateSamples,
    route: locations)
```

### ECG Samples

Electrocardiogram samples can be accessed using:

```swift
let ecgs = try db.electrocardiograms(from: .distantPast, to: distantFuture)
```

The elements returned are `Electrocardiogram`s which is a custom type similar to ``HKElectrocardiogram`` and with largely the same properties.

To get the associated voltage measurements:

```swift
let electrocardiogram: Electrocardiogram = ...
let voltages = try db.voltageMeasurements(associatedWith: electrocardiogram)
```

The voltages are `HKQuantity`s with `Volt` units.

In the database, electrocardiograms are stored in the `ecg_samples` table, which is also linked to the `samples` table via the `data_id` column.
ECG Samples have the `data_type` 144.
The samples have associated `voltage_payload` (SQLite `BLOB`), which is encoded using [protobuf](https://protobuf.dev).
The concrete specification can be viewed in the [ECGVoltageData.proto](Sources/HKDatabase/Model/ECGVoltageData.proto) file.
It contains an array of the voltage samples in microvolts, as well as the sampling frequency and an unknown property.

### Sleep schedules

The database includes a list of sleep schedules, which represent the bed time and wake time specified for the different weekdays.

```swift
let samples = try store.sleepSchedules(from: .distantPast, to: .now)
```

Sleep schedule samples are stored in the `sleep_schedule_samples` table, which contains the days for which the schedule is relevant, plus the sleep and wake time.
The samples are linked to entries in the `samples` table via the `dataId` column. 

## Related projects and info

Related: 
- [Export/import health data to JSON](https://github.com/mkhoshpour/healthkit-sample-generator)
- [Import record from Health App Export](https://github.com/Comocomo/HealthKitImporter/)
- [Create Health data during UI Tests](https://github.com/StanfordBDHG/XCTHealthKit)
