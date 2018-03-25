//
//  FxField+Enabled.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/8/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension FxField {

    // MARK: - Enabled
    
    /// Defines the Enabled flag state for later binding to a control.
    /// ```
    /// fields.add("zip").enabled(true)
    /// ```
    /// Enabled status will not be automatically bound to view or control unless this method is called during the field definition
    /// phase prior to field binding.
    ///
    /// - Parameter enabled: Default is true.
    /// - Returns: Self for further configuration.
    @discardableResult
    public func enabled(_ enabled: Bool) -> FxField {
        if view == nil {
            // use standard reactive binding strategy binding relay to view
            addReactiveBindingStrategy(FxAttribute.ENABLED) { [weak self] (view, _) in
                if let control = view as? UIControl {
                    return self?._enabled.asDriver().drive(control.rx.isEnabled)
                }
                return nil
            }
        }
        isEnabled = enabled
        return self
    }

    /// Gets and sets the current enabled state. Value may be propagated to bound view.
    public var isEnabled: Bool {
        get { return _enabled.value }
        set { _enabled.accept(newValue) }
    }

    internal var _enabled: BehaviorRelay<Bool> {
        return relay(FxAttribute.ENABLED, true)
    }

}

public extension FxFieldReactiveBase {

    /// Rx binding point for our enabled property.
    public var isEnabled: ControlProperty<Bool> {
        return ControlProperty(values: base._enabled, valueSink: Binder(base) { base, value in
            base._enabled.accept(value)
        })
    }

}
