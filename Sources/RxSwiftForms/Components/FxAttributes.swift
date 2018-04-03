//
//  FxAttributes.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/15/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

open class FxAttributes<Base:AnyObject> {

    public typealias FxAttributeHandler = (_ base: Base?, _ value: Any?) -> Void

    private weak var base: Base?

    private var map = [String:Any]()
    private var handlers: [String:FxAttributeHandler]?

    init(_ base: Base) {
        self.base = base
    }

    func addHandler(_ key: String, _ handler: @escaping FxAttributeHandler) {
        if handlers == nil {
            handlers = [:]
        }
        handlers?[key] = handler
    }

    public func removeValue(forKey key: String) {
        map.removeValue(forKey: key)
    }

    public func updateValue<T>(_ value: T?, forKey key: String) {
        if let value = value {
            map[key] = value
        } else {
            removeValue(forKey: key)
        }
        handlers?[key]?(base, value)
    }

    public subscript<T>(_ key: String) -> T? {
        get {
            return map[key] as? T
        }
        set {
            updateValue(newValue, forKey: key)
        }
    }

}
