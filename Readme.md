# iOS HealthDB Interface

A Swift interface to access health records of `healthdb.sqlite` files which have been recovered from iOS backups.

This library is a reverse-engineering effort to reconstruct Health data and allowing to access the SQLite database in a similar way to the actual `HKHealthStore` on iOS.
This library may can be useful when the original health data is lost and has to be recovered from a backup, or when a sample database is needed for testing.

## Caveats

Unfortunately, Apple makes it very difficult to work with Health Data outside the provided framework. Most problematically, a lot of `HealthKit` types don't expose properties publicly that would be needed/useful. For example, it's not possible to construct a full `HKWorkout` outside of the provided `HKHealthStore`. That's why this library uses it's own `Workout` type.

Secondly, the layout internal data structures for the SQLite database are not publicly documented, so working with the database is based on guesswork and experiments. To understand all data formats, it's necessary to observe how data is stored in the individual tables, but some of the data can't be inserted through the publicly available API. For example, `EnvironmentalAudioExposureEvent`s can only be logged by an Apple Watch. Since sample types internally use integer IDs, it's difficult to figure out those assignments.

Another (minor) problem are the database columns with encoded binary data, where again, no information about the structure is available. There is currently a lot of information not accessible and understood by this library.

Related: 
- [Export/import health data to JSON](https://github.com/mkhoshpour/healthkit-sample-generator)
- [Import record from Health App Export](https://github.com/Comocomo/HealthKitImporter/)
- [Create Health data during UI Tests](https://github.com/StanfordBDHG/XCTHealthKit)
