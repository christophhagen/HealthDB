import Foundation
import HealthKit

extension HKAudiogramSample: BinarySample {

    static func from(object: ObjectData, data: Data) -> Self? {
        let points: [HKAudiogramSensitivityPoint]
        do {
            let decoder = try NSKeyedUnarchiver(forReadingFrom: data)
            decoder.requiresSecureCoding = false

            guard let values = decoder.decodeObject(of: NSArray.self, forKey: NSKeyedArchiveRootObjectKey) as? [HKAudiogramSensitivityPoint] else {
                return nil
            }
            points = values
        } catch {
            return nil
        }

        return .init(sensitivityPoints: points, start: object.startDate, end: object.endDate, metadata: object.metadata)
    }
}
