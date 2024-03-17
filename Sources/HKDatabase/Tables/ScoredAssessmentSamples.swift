import Foundation
import SQLite

struct ScoredAssessmentSamples {

    func create(in database: Connection, referencing samples: SamplesTable) throws {
        try database.execute("CREATE TABLE scored_assessment_samples (data_id INTEGER PRIMARY KEY REFERENCES samples (data_id) ON DELETE CASCADE, score INTEGER NOT NULL, answers BLOB NOT NULL, risk INTEGER NOT NULL)")
    }

    let table = Table("scored_assessment_samples")

    let dataId = Expression<Int>("data_id")

    // NOTE: Technically optional
    let score = Expression<Int>("score")

    // NOTE: Technically optional
    let answers = Expression<Data>("answers")

    let risk = Expression<Int>("risk")
}
