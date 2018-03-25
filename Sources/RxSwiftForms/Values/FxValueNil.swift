//
//  FxValueNil.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/9/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation

public struct FxValueNil: FxValue {
    public var isEmpty: Bool {
        return true
    }
    public var asText: String {
        return ""
    }
    public func asType<T>() -> T? {
        return nil
    }
    public func isEqual(_ value: FxValue) -> Bool {
        if let value = value as? FxValueNil {
            return value.isEmpty
        }
        return asText == value.asText
    }
    public mutating func reset() {
        // nil is nil
    }
}
