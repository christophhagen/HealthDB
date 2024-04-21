import Foundation

@frozen
public struct BiDictionary<Key: Hashable, Value: Hashable> {
    @usableFromInline
    internal var _keyValueDict: Dictionary<Key, Value>

    @usableFromInline
    internal var _valueKeyDict: Dictionary<Value, Key>

    @inlinable
    @inline(__always)
    internal init(
        _keyValueDict keys: Dictionary<Key, Value>,
        _valueKeyDict values: Dictionary<Value, Key>
    ) {
        self._keyValueDict = keys
        self._valueKeyDict = values
    }
}

extension BiDictionary {
    @inlinable
    @inline(__always)
    public var keys: Set<Key> { Set(_keyValueDict.keys) }

    @inlinable
    @inline(__always)
    public var values: Set<Value> { Set(_valueKeyDict.keys) }
}

extension BiDictionary {
    @inlinable
    public subscript(key key: Key) -> Value? {
        get {
            return _keyValueDict[key]
        }
        _modify {
            var value: Value? = nil
            value = _keyValueDict[key]

            defer {
                if let value = value {
                    _valueKeyDict[value] = key
                }
                _keyValueDict[key] = value
            }

            yield &value
        }
    }

    @inlinable
    public subscript(value value: Value) -> Key? {
        get {
            return _valueKeyDict[value]
        }
        _modify {
            var key: Key? = nil
            key = _valueKeyDict[value]

            defer {
                if let key = key {
                    _keyValueDict[key] = value
                }
                _valueKeyDict[value] = key
            }

            yield &key
        }
    }
}

extension BiDictionary {
    @inlinable
    @inline(__always)
    public init() {
        self._keyValueDict = Dictionary<Key, Value>()
        self._valueKeyDict = Dictionary<Value, Key>()
    }
}

extension BiDictionary: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init()
        for element in elements {
            self[key: element.0] = element.1
        }
    }
}

extension BiDictionary: Sequence {
    
    public func makeIterator() -> Dictionary<Key, Value>.Iterator {
        _keyValueDict.makeIterator()
    }

    public typealias Iterator = Dictionary<Key, Value>.Iterator

}
