import Foundation

extension Data {

    public var hex: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }

    // Convert 0 ... 9, a ... f, A ...F to their decimal value,
    // return nil for all other input characters
    private func decodeNibble(_ u: UInt16) -> UInt8? {
        switch(u) {
        case 0x30 ... 0x39:
            return UInt8(u - 0x30)
        case 0x41 ... 0x46:
            return UInt8(u - 0x41 + 10)
        case 0x61 ... 0x66:
            return UInt8(u - 0x61 + 10)
        default:
            return nil
        }
    }

    public init?(hex string: String) {
        let utf16 = string.utf16
        self.init(capacity: utf16.count/2)

        var i = utf16.startIndex
        guard utf16.count % 2 == 0 else {
            return nil
        }
        while i != utf16.endIndex {
            guard let hi = decodeNibble(utf16[i]),
                let lo = decodeNibble(utf16[utf16.index(i, offsetBy: 1, limitedBy: utf16.endIndex)!]) else {
                    return nil
            }
            var value = hi << 4 + lo
            self.append(&value, count: 1)
            i = utf16.index(i, offsetBy: 2, limitedBy: utf16.endIndex)!
        }
    }
}

extension Data {

    func asUUID() -> UUID? {
        .init(data: self)
    }

    var uuidString: String? {
        guard self.count == 16 else {
            return nil
        }
        let h = Array(self)
        let parts = [h[0..<4], h[4..<6], h[6..<8], h[8..<10], h[10..<16]]
        return parts.map { Data($0).hex }.joined(separator: "-")
    }
}

extension UUID {

    init?(data: Data) {
        guard let uuidString = data.uuidString else {
            return nil
        }
        self.init(uuidString: uuidString)
    }

    var data: Data? {
        .init(hex: uuidString.replacingOccurrences(of: "-", with: ""))
    }
}


extension Data {


    func convert<T>(into value: T) -> T {
        withUnsafeBytes {
            $0.baseAddress!.load(as: T.self)
        }
    }

    init<T>(from value: T) {
        var target = value
        self = Swift.withUnsafeBytes(of: &target) {
            Data($0)
        }
    }
}
