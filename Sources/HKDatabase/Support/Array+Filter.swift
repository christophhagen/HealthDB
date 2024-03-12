import Foundation

extension Array where Element: AnyObject {

    func limited(by limit: Int?) -> [Element] {
        guard let limit else {
            return self
        }
        return Array(prefix(limit))
    }

    func sorted(using sortDescriptors: [NSSortDescriptor]?) -> [Element] {
        guard let sortDescriptors else {
            return self
        }
        return sorted {
            for sortDescriptor in sortDescriptors {
                switch sortDescriptor.compare($0, to: $1) {
                case .orderedAscending: return true
                case .orderedDescending: return false
                case .orderedSame: continue
                }
            }
            return false
        }
    }
}

extension Array where Element: AnyObject {

    public func filtered(using predicate: NSPredicate?) -> [Element] {
        guard let predicate else {
            return self
        }
        return (self as NSArray).filtered(using: predicate) as! [Element]
    }
}
