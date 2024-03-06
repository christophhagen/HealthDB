import Foundation

extension String {

    var nonEmpty: String? {
        self != "" ? self : nil
    }

    func withFirstLetterLowercased() -> String {
        let first = String(prefix(1)).lowercased()
        let other = String(dropFirst())
        return first + other
    }
}
