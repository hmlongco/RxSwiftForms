//
//  FxValues.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/21/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation

public protocol FxValueFactory {
    func make<T>(_ value:T) -> FxValue
}

open class FxValues {

    public static var instance = FxValues()

    public static var types = [Int:FxValueFactory]()

    public static func register<T>(_ type: T, factory: FxValueFactory) {
        FxValues.types[ObjectIdentifier(T.self).hashValue] = factory
    }

    public static func make<T>(_ value: T?) -> FxValue {
        return instance.make(value)
    }

    public func make<T>(_ value: T?) -> FxValue {
        guard let value = value else {
            return FxValueNil()
        }
        if let value = value as? String {
            return FxValueText(value)
        }
        if let value = value as? Bool {
            return FxValueBool(value)
        }
        if let factory = FxValues.types[ObjectIdentifier(T.self).hashValue] {
            return factory.make(value)
        }
        return FxValueGeneric(value)
    }
    
}
