import Foundation
import SQLite
import CoreLocation

struct LocationSeriesDataTable {

    let table = Table("location_series_data")

    /// `location_series_data[series_identifier]` <-> `workout_activities[ROW_ID]`
    let seriesIdentifier = SQLite.Expression<Int>("series_identifier")

    let timestamp = SQLite.Expression<Double>("timestamp")

    let longitude = SQLite.Expression<Double>("longitude")

    let latitude = SQLite.Expression<Double>("latitude")

    let altitude = SQLite.Expression<Double>("altitude")

    let speed = SQLite.Expression<Double>("speed")

    let course = SQLite.Expression<Double>("course")

    let horizontalAccuracy = SQLite.Expression<Double>("horizontal_accuracy")

    let verticalAccuracy = SQLite.Expression<Double>("vertical_accuracy")

    let speedAccuracy = SQLite.Expression<Double>("speed_accuracy")

    let courseAccuracy = SQLite.Expression<Double>("course_accuracy")

    let signalEnvironment = SQLite.Expression<Double>("signal_environment")

    func locations(for seriesId: Int, in database: Connection) throws -> [CLLocation] {
        let query = table.filter(seriesIdentifier == seriesId)
        return try database.prepare(query).map(location)
    }

    func locations(from start: Date, to end: Date, in database: Connection) throws -> [CLLocation] {
        let startTime = start.timeIntervalSinceReferenceDate
        let endTime = end.timeIntervalSinceReferenceDate
        let query = table.filter(timestamp >= startTime && timestamp <= endTime)
        return try database.prepare(query).map(location)
    }

    func location(row: Row) -> CLLocation {
        .init(
            coordinate: .init(
                latitude: row[latitude],
                longitude: row[longitude]),
            altitude: row[altitude],
            horizontalAccuracy: row[horizontalAccuracy],
            verticalAccuracy: row[horizontalAccuracy],
            course: row[course],
            courseAccuracy: row[courseAccuracy],
            speed: row[speed],
            speedAccuracy: row[speedAccuracy],
            timestamp: .init(timeIntervalSinceReferenceDate: row[timestamp]),
            sourceInfo: .init())
    }

    func create(in database: Connection, referencing dataSeries: DataSeriesTable) throws {
        try database.execute("CREATE TABLE location_series_data (series_identifier INTEGER NOT NULL REFERENCES data_series(hfd_key) DEFERRABLE INITIALLY DEFERRED, timestamp REAL NOT NULL, longitude REAL NOT NULL, latitude REAL NOT NULL, altitude REAL NOT NULL, speed REAL NOT NULL, course REAL NOT NULL, horizontal_accuracy REAL NOT NULL, vertical_accuracy REAL NOT NULL, speed_accuracy REAL NOT NULL, course_accuracy REAL NOT NULL, signal_environment INTEGER NOT NULL, PRIMARY KEY (series_identifier, timestamp)) WITHOUT ROWID")
    }

    func insert(_ sample: CLLocation, seriesId: Int, in database: Connection) throws {
        try database.run(table.insert(
            seriesIdentifier <- seriesId,
            timestamp <- sample.timestamp.timeIntervalSinceReferenceDate,
            longitude <- sample.coordinate.longitude,
            latitude <- sample.coordinate.latitude,
            altitude <- sample.altitude,
            speed <- sample.speed,
            course <- sample.course,
            horizontalAccuracy <- sample.horizontalAccuracy,
            horizontalAccuracy <- sample.verticalAccuracy,
            speedAccuracy <- sample.speedAccuracy,
            courseAccuracy <- sample.courseAccuracy,
            signalEnvironment <- 1
        ))
    }
}
