//
//  FxValues.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/21/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation

public class FxValues {

    public static var instance = FxValues()

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
        return FxValueGeneric(value)
    }
    
}
