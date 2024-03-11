# iOS HealthDB Interface

A Swift interface to access health records of `healthdb.sqlite` files which have been recovered from iOS backups.

This library is a reverse-engineering effort to reconstruct Health data and allowing to access the SQLite database in a similar way to the actual `HKHealthStore` on iOS.
This library may can be useful when the original health data is lost and has to be recovered from a backup, or when a sample database is needed for testing.

## Status

### Implemented features

- Reading [Category samples](#category-samples)
- [Quantity samples](#quantity-samples) and [series](#quantity-sample-series)
- [Workout routes / location samples](#location-data-series)
- [Workouts (+ Activities, Events)](#workouts)
- [User characteristics](#basic-user-characteristics-and-values)

### Not implemented

- Medical records and prescriptions
- Other [sample types](#unhandled-samples)
- Workout statistics, workout zones
- Several metadata fields
- Inserting most data
- Achievements

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
Copy the file to an accessible location, and create a database object:

```swift
import HKDatabase

let db = try HealthDatabase(url: ...)
```

## Basic user characteristics and values

Similar to the `HKHealthStore`, these can be accessed through separate functions on `HealthDatabase`:

```swift
func biologicalSex() throws -> HKBiologicalSex
func bloodType() throws -> HKBloodType
func dateOfBirthComponents() throws -> DateComponents
func fitzpatrickSkinType() throws -> HKFitzpatrickSkinType
func wheelchairUse() throws -> HKWheelchairUse
```

Access all values in the table through:

```swift
func keyValuePairs() throws -> [KeyValueEntry]
```

Internally, they are stored in the `key_value_secure` table.

## Samples

Samples are separated into different types.

In the database, the initial entry point is always the `samples` table. It contains the date interval and the data type.
This type then determines where the additional data is stored.

The known sample types are managed in the `SampleType` enum


### Category samples

Access category samples through:

```swift
let samples: [HKCategorySample] = try db.samples(type: .vomiting)
```

You can also use the types from [HealthKitExtensions](https://github.com/christophhagen/HealthKitExtensions):

```swift
let samples: [Vomiting] = try db.samples(from: .distantPast, to: .now)
```

The functions will fail with a `HKNotSupportedError` if the internal `SampleType` identifier is not known.

Internally, the additional data of the samples is stored in the `category_samples` table where `samples.data_id == category_samples.data_id`

There are at least these unknown category sample identifiers: 112, 116, 178.

To access unknown samples:

```swift
let samples = try db.unknownCategorySamples(
    rawDataType: 147, 
    as: .lowHeartRateEvent, 
    from: .distantPast, 
    to: .now)
```

This function will produce errors if the sample data contains invalid values, which may happen when the `SampleType` doesn't match the `HKCategoryTypeIdentifier`.
If you figure out the identifier for a currently unknown type, please open an issue, and it will be included.

### Quantity samples

```swift
let samples: [HKQuantitySample] = try db.samples(type: .bodyMass)
let samples: [BodyMass] = try db.samples(from: .distantPast, to: .now)
```

The functions will fail with a `HKNotSupportedError` if the internal `SampleType` identifier is not known.
The value in the database is interpreted according to the default unit of each sample type.

To access unknown samples:

```swift
let samples = try db.unknownQuantitySamples(
        rawDataType: 3, 
        as: .bodyMass, 
        unit: .gramUnit(with: .kilo), 
        from: .distantPast, 
        to: .now)
```

Internally, the additional data of the samples is stored in the `quantity_samples` table where `samples.data_id == quantity_samples.data_id`.
The database also stores an "original unit" for some samples, but this data is not exported.
The unit is contained in the `unit_string` column of the `unit_strings` table where `quantity_samples.original_unit == unit_strings.ROWID`.

### Unhandled samples

There are many sample tables in the database, and all appear to be linked by their `data_id` column to the `data_id` column in the `samples` table.

| Name | Content |
|---|---|
`account_owner_samples` |
`allergy_record_samples`
`binary_samples` | Binary Samples
`category_samples` | Category Samples, Unknown categories: 112, 116, 178
`clinical_note_record_samples`
`clinical_record_samples`
`condition_record_samples`
`coverage_record_samples`
`diagnostic_test_report_samples`
`diagnostic_test_result_samples`
`ecg_samples` | ECG Samples
`medication_dispense_record_samples`
`medication_dose_event_samples`
`medication_order_samples`
`medication_record_samples`
`procedure_record_samples`
`quantity_samples` | Quantity samples, like body measurements
`scored_assessment_samples`
`signed_clinical_data_record_samples`
`sleep_schedule_samples` | Sleep Schedule Samples
`state_of_mind_samples`
`unknown_record_samples`
`vaccination_record_samples`
`verifiable_clinical_record_samples`
`workout_zones_samples`

### Location data series

Locations are grouped into data series, which can be selected based on a date range:

```swift
let locationSeries = try database.locationSeries(from: .distantPast, to: .now)
```

All series overlapping the provided date range are returned.
The locations can then be accessed using the relevant series:

```swift
let series = locationSeries.first!
let locations: [CLLocation] = try database.locations(in: series)
```
Location series data doesn't appear to be directly linked to workouts, so the `samples` table is searched for a data series with an overlapping date interval.
It's also possible to directly select location samples based on a time interval.
In this case, samples from different location series may be returned.

```swift
let locations = try database.locations(from: .distantPast, to: .now)
```

Data series are partially stored in the table `data_series`, but they also contain a sample in the `samples` table with `data_type == 102` and the same `data_id`.
The `data_series` table seems to only contain location series.

The column `hfd_key` links the data series to entries in the table `location_series_data` where `data_series.hfd_key == location_series_data.series_identifier`.

### Quantity sample series

Some quantity samples are arranged in data series, which are associated with a specific sample.
This concerns mostly workout data, like heart rate, cycling power, or vertical oscillation data.

```swift
let heartRateSeries = try db.quantitySampleSeries(
    ofType: HeartRate.self, 
    from: .distantPast, 
    to: .now)
let series = heartRateSeries.first!
let samples: [HeartRate] = try db.quantities(in: series)
```

**Note** The samples of the series have no `device` or `metadata` associated with it.
Check the `sample` property of the data series to get those values.

There are also functions to get simple `HKQuantitySample`s, and the possibility to manually select the raw sample type for unsupported quantity types.

If you don't care about the series and just want all samples of a specific type, you can request the samples directly:

```swift
let samples: [HeartRate] = try db.quantitySamplesIncludingSeriesData(from: start, to: end)
```

**Note**: If you select samples directly, then the `device` and `metadata` properties of the `HKQuantitySample`s will be set to the value of the data series sample.

**Note**: It's more efficient to first select series and then request the samples, since each relevant sample must be compared against the `data_series` table, which can take a long time for large date intervals and databases with a lot of samples.

Each data series contains an entry in `samples`, with the `data_type` according to the sample type.
An entry in the `quantity_sample_series` with the same `data_id` as the sample contains the series specification, including the number of samples.

The actual values of the data series are contained in `quantity_series_data`, where `quantity_sample_series.hfd_key == quantity_series_data.series_identifier`.
The `value` is scaled in the default unit of the sample type.

It's not obvious from the entry in `samples`, if a data series is linked to it.

For each data series, there is also an entry in `quantity_sample_statistics` where the `owner_id == samples.data_id`.

### Workouts

Workouts can be queried from the database similar to other samples:

```swift
let workouts = try db.workouts(from: .distantPast, to: .now)
```

`HealthKit` doesn't allow the creation of `HKWorkout`s outside of the `HKHealthStore`, so this framework uses it's own `Workout` type.
The workouts have mostly similar fields, including the associated `workoutActivities` and `workoutEvents`.
Statistics are not yet included.

It's possible to insert `Workout`s into a proper `HKHealthStore`:

```swift
let heartRateSamples: [HKSample] = ...
let routePoints: [CLLocation] = ...
let savedWorkout: HKWorkout = try workout.insert(
    into: HKHealthStore(), 
    samples: heartRateSamples,
    route: routePoints)
```

Workouts are entries in the `samples` table with `data_type == 79`. 
There is a matching entry in `workouts` with `samples.data_id == workouts.data_id`.

Workout activities are contained in `workout_activities` where `workouts.data_id == workout_activities.owner_id`.
Similarly, workout events are contained in `workout_events` where `workouts.data_id == workout_events.owner_id`.

## Related projects and info

Related: 
- [Export/import health data to JSON](https://github.com/mkhoshpour/healthkit-sample-generator)
- [Import record from Health App Export](https://github.com/Comocomo/HealthKitImporter/)
- [Create Health data during UI Tests](https://github.com/StanfordBDHG/XCTHealthKit)
