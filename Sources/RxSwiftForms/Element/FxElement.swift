//
//  FxElement.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/8/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public typealias FxAttributeBindingStrategy = (_ view: UIView?, _ value: Any?) -> Void
public typealias FxReactiveBindingStrategy = (_ view: UIView?, _ value: Any?) -> Disposable?

open class FxElement: FxBase {

    // MARK: - View Binding

    /// The view/textfield/control bound to this field by FxForm.
    public weak var view: UIView? {
        didSet {
            view?.fx.element = self
        }
    }

    // MARK: - Attribute Binding Support

    /// Primarily an internal function used by configuration routines to set attributes. If defined, values will be bound to fields
    /// using the appropriate binding strategy.
    public func updateAttribute<T>( _ value: T?, forkey key: String) {
        super.attributes.updateValue(value, forKey: key)
        if let view = view, let strategy = _attributeBindingStrategies[key] {
            strategy(view, value)
        }
    }

    /// Primarily an internal function used by configuration routines to add the appropriate binding strategy.
    public func addAttributeBindingStrategy(_ key: String, bind: @escaping FxAttributeBindingStrategy) {
        if _attributeBindingStrategies[key] == nil && view == nil {
            _attributeBindingStrategies[key] = bind
        }
    }

    /// Primarily an internal function used by configuration routines to add the appropriate binding strategy.
    public func addReactiveBindingStrategy(_ key: String, bind: @escaping FxReactiveBindingStrategy) {
        if _reactiveBindingStrategies[key] == nil && view == nil {
            _reactiveBindingStrategies[key] = bind
        }
    }

    internal func performAttributeBinding() {
        guard let view = view else {
            return
        }
        // perform attribute binding strategies
        for (key, strategy) in _attributeBindingStrategies {
            strategy(view, attributes[key])
        }
        // perform reactive attributes
        for (key, strategy) in _reactiveBindingStrategies {
            if let disposable = strategy(view, attributes[key]) {
                disposable.disposed(by: _disposeBag)
            }
        }
        _reactiveBindingStrategies = [:]
    }

    internal var _attributeBindingStrategies = [String:FxAttributeBindingStrategy]()
    internal var _reactiveBindingStrategies = [String:FxReactiveBindingStrategy]()

    internal var _disposeBag = DisposeBag()

}

extension FxViewAttributes {
    var element: FxElement? {
        get {
            let result: FxWeakBox<FxElement>? = self[FxAttribute.ELEMENT]
            return result?.value
        }
        set {
            updateValue(FxWeakBox(newValue), forKey: FxAttribute.ELEMENT)
        }
    }
}
