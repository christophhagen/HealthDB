import Foundation
import CoreLocation

extension Array where Element == CLLocation {

    var distance: CLLocationDistance {
        guard var current = first else {
            return 0
        }
        var result: CLLocationDistance = 0
        for next in dropFirst() {
            result += next.distance(from: current)
            current = next
        }
        return result
    }
}
