import Foundation
import HealthKit

public struct RawCategory: HKObjectProtocol {

    public let startDate: Date

    public let endDate: Date

    public let category: Int

    // MARK: HKObjectProtocol

    public let uuid: UUID

    public let metadata: [String : Any]?

    public let device: HKDevice?
}
