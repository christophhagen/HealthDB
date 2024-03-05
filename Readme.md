# iOS HealthDB Interface

A Swift interface to access health records of `healthdb.sqlite` files which have been recovered from iOS backups.

This library is a reverse-engineering effort to reconstruct Health data and allowing to access the SQLite database in a similar way to the actual `HKHealthStore` on iOS.
This library may can be useful when the original health data is lost and has to be recovered from a backup, or when a sample database is needed for testing.
