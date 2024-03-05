import Foundation

extension Double {
    
    var roundedInt: Int {
        Int(rounded())
    }
    
    var distanceAsKilometer: String {
        guard self < 0.1 else {
            return String(format: "%.2f km", self)
        }
        return String(format: "%.1f m", self / 1000)
    }

    var lengthAsMeter: String {
        guard self < 1000 else {
            return String(format: "%.2f km", self / 1000)
        }
        guard self < 100 else {
            return String(format: "%.0f m", self)
        }
        return String(format: "%.1f m", self)
    }

    var meter: String {
        guard self < 100 else {
            return String(format: "%.0f m", self)
        }
        return String(format: "%.1f m", self)
    }

    var speedAsMetersPerSecond: String {
        String(format: "%.1f m/s", self)
    }

    func asDegrees(decimals: Int = 1) -> String {
        String(format: "%.\(decimals)f°", self)
    }
}

extension TimeInterval {
    
    var durationString: String {
        let totalSeconds = roundedInt
        guard totalSeconds >= 60 else {
            return String(format: "%.3f s", self)
        }
        let seconds = totalSeconds % 60
        let totalMinutes = totalSeconds / 60
        guard totalMinutes >= 60 else {
            return String(format: "%d:%02d", totalMinutes, seconds)
        }
        let minutes = totalMinutes % 60
        let totalHours = totalMinutes / 60
        return String(format: "%d:%02d:%02d", totalHours, minutes, seconds)
    }
}
