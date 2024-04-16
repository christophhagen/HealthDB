import Foundation
import HealthKit

public protocol HKObjectProtocol {

    /// The universally unique identifier (UUID) for this HealthKit object.
    var uuid: UUID { get }

    /// The metadata for this HealthKit object.
    var metadata: [String : Any]? { get }

    /// The device that generated the data for this object.
    var device: HKDevice? { get }

}
