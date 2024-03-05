import Foundation

extension String {

    var nonEmpty: String? {
        self != "" ? self : nil
    }
}
