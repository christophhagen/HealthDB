import HealthKit
import HealthKitExtensions

extension Array where Element: HKSample {

    func sorted(by sortingMethod: SampleSortingMethod?) -> [Element] {
        guard let sortingMethod else {
            return self
        }
        return sorted(by: sortingMethod)
    }
}
