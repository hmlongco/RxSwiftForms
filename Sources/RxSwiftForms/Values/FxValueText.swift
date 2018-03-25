//
//  FxValueText.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/9/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation

public struct FxValueText: FxValue {
    private var _value: String
    public init(_ value: String) {
        self._value = value
    }
    public var isEmpty: Bool {
        return _value.isEmpty
    }
    public var asText: String {
        return _value
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
        _value = ""
    }
}
