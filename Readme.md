# iOS HealthDB Interface

A Swift interface to access health records of `healthdb.sqlite` files which have been recovered from iOS backups.

This library is a reverse-engineering effort to reconstruct Health data and allowing to access the SQLite database in a similar way to the actual `HKHealthStore` on iOS.
This library may can be useful when the original health data is lost and has to be recovered from a backup, or when a sample database is needed for testing.

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

```
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

## Caveats

Unfortunately, Apple makes it very difficult to work with Health Data outside the provided framework. Most problematically, a lot of `HealthKit` types don't expose properties publicly that would be needed/useful. For example, it's not possible to construct a full `HKWorkout` outside of the provided `HKHealthStore`. That's why this library uses it's own `Workout` type.

Secondly, the layout internal data structures for the SQLite database are not publicly documented, so working with the database is based on guesswork and experiments. To understand all data formats, it's necessary to observe how data is stored in the individual tables, but some of the data can't be inserted through the publicly available API. For example, `EnvironmentalAudioExposureEvent`s can only be logged by an Apple Watch. Since sample types internally use integer IDs, it's difficult to figure out those assignments.

Another (minor) problem are the database columns with encoded binary data, where again, no information about the structure is available. There is currently a lot of information not accessible and understood by this library.

Related: 
- [Export/import health data to JSON](https://github.com/mkhoshpour/healthkit-sample-generator)
- [Import record from Health App Export](https://github.com/Comocomo/HealthKitImporter/)
- [Create Health data during UI Tests](https://github.com/StanfordBDHG/XCTHealthKit)
