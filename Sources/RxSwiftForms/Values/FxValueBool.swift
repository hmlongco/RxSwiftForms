//
//  FxValueBool.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/9/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation

public struct FxValueBool: FxValue {
    private var _value: Bool
    public init(_ value: Bool) {
        self._value = value
    }
    public var isEmpty: Bool {
        return !_value // false is empty
    }
    public var asText: String {
        return String(describing: _value)
    }
    public func asType<T>() -> T? {
        if let value = _value as? T {
            return value
        }
        return nil
    }
    public func isEqual(_ value: FxValue) -> Bool {
        return self.asBool == value.asBool
    }
    public mutating func reset() {
        _value = false
    }
}
