//
//  FxValueGeneric.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/9/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation

public struct FxValueGeneric<T>: FxValue {
    private var _value: T?
    public init(_ value: T?) {
        self._value = value
    }
    public var isEmpty: Bool {
        return _value == nil || asText.isEmpty
    }
    public var asText: String {
        if let value = _value {
            return "\(value)"
        }
        return ""
    }
    public func asType<T>() -> T? {
        if let value = _value as? T {
            return value
        }
        return nil
    }
    public func isEqual(_ value: FxValue) -> Bool {
        return asText == value.asText
    }
    public mutating func reset() {
        _value = nil
    }
}
