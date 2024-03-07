import Foundation
import SQLite
import CoreLocation

struct LocationSeriesDataTable {

    let table = Table("location_series_data")

    /// `location_series_data[series_identifier]` <-> `workout_activities[ROW_ID]`
    let seriesIdentifier = Expression<Int>("series_identifier")

    let timestamp = Expression<Double>("timestamp")

    let longitude = Expression<Double>("longitude")

    let latitude = Expression<Double>("latitude")

    let altitude = Expression<Double>("altitude")

    let speed = Expression<Double>("speed")

    let course = Expression<Double>("course")

    let horizontalAccuracy = Expression<Double>("horizontal_accuracy")

    let verticalAccuracy = Expression<Double>("vertical_accuracy")

    let speedAccuracy = Expression<Double>("speed_accuracy")

    let courseAccuracy = Expression<Double>("course_accuracy")

    let signalEnvironment = Expression<Double>("signal_environment")
    
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

    func create(references dataSeries: DataSeriesTable, in database: Connection) throws {
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
