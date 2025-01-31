import Foundation
import SQLite

struct ECGSamplesTable {

    let table = Table("ecg_samples")

    func create(in database: Connection, referencing samples: SamplesTable) throws {
        try database.execute("CREATE TABLE ecg_samples (data_id INTEGER PRIMARY KEY REFERENCES samples (data_id) ON DELETE CASCADE, private_classification INTEGER NOT NULL, average_heart_rate REAL, voltage_payload BLOB NOT NULL, symptoms_status INTEGER NOT NULL)")
    }

    let dataId = SQLite.Expression<Int>("data_id")

    let privateClassification = SQLite.Expression<Int>("private_classification")

    let averageHeartRate = SQLite.Expression<Double?>("average_heart_rate")

    let voltagePayload = SQLite.Expression<Data>("voltage_payload")

    let symptomsStatus = SQLite.Expression<Int>("symptoms_status")

    func payload(for dataId: Int, in database: Connection) throws -> ECGVoltageData? {
        try database.pluck(table.filter(self.dataId == dataId))
            .map {
                let data = $0[voltagePayload]
                return try ECGVoltageData(serializedData: data)
            }
    }
}
