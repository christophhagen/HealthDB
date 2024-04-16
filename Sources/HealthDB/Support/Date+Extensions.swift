import Foundation

private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .short
    df.timeStyle = .short
    return df
}()

extension Date {

    var timeAndDateText: String {
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: self)
    }

    func timeAndDateText(in timeZone: TimeZone) -> String {
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
}
