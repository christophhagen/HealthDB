import Foundation

protocol BinarySample {

    static func from(object: ObjectData, data: Data) -> Self?
}
