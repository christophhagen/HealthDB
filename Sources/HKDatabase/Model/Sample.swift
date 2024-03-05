import Foundation

struct Sample {

    let startDate: Date

    let endDate: Date

    let dataType: SampleType

    let quantity: Double?

    let originalQuantity: Double?

    let originalUnit: String?

    let timeZoneName: String?

    var timeZone: TimeZone? {
        guard let timeZoneName else {
            return nil
        }
        guard let zone = TimeZone(identifier: timeZoneName) else {
            print("No time zone for '\(timeZoneName)'")
            return nil
        }
        return zone
    }

    var duration: TimeInterval {
        endDate.timeIntervalSince(startDate)
    }

    var originalQuantityText: String {
        guard let originalQuantity, let originalUnit else {
            return ""
        }
        return " (\(originalQuantity) \(originalUnit))"

    }

    var quantityText: String {
        guard let quantity else {
            return "-"
        }
        return "\(quantity)"
    }

    var dateText: String {
        startDate.timeAndDateText(in: timeZone ?? .current)
    }
}

extension Sample: CustomStringConvertible {

    var description: String {
        "\(dateText) (\(Int(duration)) s) \(quantityText)\(originalQuantityText)"
    }
}

