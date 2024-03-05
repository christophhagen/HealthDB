// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: EventMetadata.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

/// Wrapper for workout event metadata
struct WorkoutEventMetadata {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// All metadata elements
  var elements: [WorkoutEventMetadata.Element] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  struct Element {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    var key: String = String()

    var unsignedValue: UInt64 {
      get {return _unsignedValue ?? 0}
      set {_unsignedValue = newValue}
    }
    /// Returns true if `unsignedValue` has been explicitly set.
    var hasUnsignedValue: Bool {return self._unsignedValue != nil}
    /// Clears the value of `unsignedValue`. Subsequent reads from it will return its default value.
    mutating func clearUnsignedValue() {self._unsignedValue = nil}

    var quantity: WorkoutEventMetadata.Element.Quantity {
      get {return _quantity ?? WorkoutEventMetadata.Element.Quantity()}
      set {_quantity = newValue}
    }
    /// Returns true if `quantity` has been explicitly set.
    var hasQuantity: Bool {return self._quantity != nil}
    /// Clears the value of `quantity`. Subsequent reads from it will return its default value.
    mutating func clearQuantity() {self._quantity = nil}

    var unknownFields = SwiftProtobuf.UnknownStorage()

    struct Quantity {
      // SwiftProtobuf.Message conformance is added in an extension below. See the
      // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
      // methods supported on all messages.

      var value: Double = 0

      var unit: String = String()

      var unknownFields = SwiftProtobuf.UnknownStorage()

      init() {}
    }

    init() {}

    fileprivate var _unsignedValue: UInt64? = nil
    fileprivate var _quantity: WorkoutEventMetadata.Element.Quantity? = nil
  }

  init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension WorkoutEventMetadata: @unchecked Sendable {}
extension WorkoutEventMetadata.Element: @unchecked Sendable {}
extension WorkoutEventMetadata.Element.Quantity: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension WorkoutEventMetadata: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "WorkoutEventMetadata"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "elements"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.elements) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.elements.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.elements, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: WorkoutEventMetadata, rhs: WorkoutEventMetadata) -> Bool {
    if lhs.elements != rhs.elements {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension WorkoutEventMetadata.Element: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = WorkoutEventMetadata.protoMessageName + ".Element"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "key"),
    4: .same(proto: "unsignedValue"),
    6: .same(proto: "quantity"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.key) }()
      case 4: try { try decoder.decodeSingularUInt64Field(value: &self._unsignedValue) }()
      case 6: try { try decoder.decodeSingularMessageField(value: &self._quantity) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if !self.key.isEmpty {
      try visitor.visitSingularStringField(value: self.key, fieldNumber: 1)
    }
    try { if let v = self._unsignedValue {
      try visitor.visitSingularUInt64Field(value: v, fieldNumber: 4)
    } }()
    try { if let v = self._quantity {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 6)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: WorkoutEventMetadata.Element, rhs: WorkoutEventMetadata.Element) -> Bool {
    if lhs.key != rhs.key {return false}
    if lhs._unsignedValue != rhs._unsignedValue {return false}
    if lhs._quantity != rhs._quantity {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension WorkoutEventMetadata.Element.Quantity: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = WorkoutEventMetadata.Element.protoMessageName + ".Quantity"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "value"),
    2: .same(proto: "unit"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularDoubleField(value: &self.value) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.unit) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.value != 0 {
      try visitor.visitSingularDoubleField(value: self.value, fieldNumber: 1)
    }
    if !self.unit.isEmpty {
      try visitor.visitSingularStringField(value: self.unit, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: WorkoutEventMetadata.Element.Quantity, rhs: WorkoutEventMetadata.Element.Quantity) -> Bool {
    if lhs.value != rhs.value {return false}
    if lhs.unit != rhs.unit {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
