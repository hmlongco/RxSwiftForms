//
//  FxValue.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/19/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation

public protocol FxValue {
    var isEmpty: Bool { get }
    var asText: String { get }
    func asType<T>() -> T?
    func isEqual(_ value: FxValue) -> Bool
    mutating func reset()
}

public extension FxValue {
    public var asBool: Bool {
        if let result: Bool = asType() {
            return result
        }
        return asText == "true" || asInt != 0
    }
    public var asDouble: Double {
        if let result: Double = asType() {
            return result
        }
        return Double(asText) ?? 0.0
    }
    public var asInt: Int {
        if let result: Int = asType() {
            return result
        }
        return Int(asDouble)
    }
}
