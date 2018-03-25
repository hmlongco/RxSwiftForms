//
//  FxField+Properties.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/20/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension FxField {

    // MARK: - Hidden
    
    /// Defines the Hidden flag state for later binding to a view or control.
    ///
    /// **Note that hidden fields are not validated.**
    /// ```
    /// fields.add("zip").hidden(true)
    /// ```
    /// Hidden status will not be automatically bound to view or control unless this method is called during the field definition
    /// phase prior to field binding.
    ///
    /// - Parameter hidden: Default is false.
    /// - Returns: Self for further configuration.
    @discardableResult
    public func hidden(_ hidden: Bool) -> FxField {
        if view == nil {
            // use standard reactive binding strategy binding relay to view
            addReactiveBindingStrategy(FxAttribute.HIDDEN) { [weak self] (view, _) in
                if let view = view {
                    return self?._hidden.asDriver().drive(view.rx.isHidden)
                }
                return nil
            }
        }
        isHidden = hidden
        return self
    }

    /// Gets and sets the current hidden state. Value may be propagated to bound view.
    public var isHidden: Bool {
        get { return _hidden.value }
        set { _hidden.accept(newValue) }
    }

    internal var _hidden: BehaviorRelay<Bool> {
        return relay(FxAttribute.HIDDEN, false)
    }

}

public extension FxFieldReactiveBase  {

    /// Rx binding point for hidden property.
    public var isHidden: ControlProperty<Bool> {
        return ControlProperty(values: base._hidden, valueSink: Binder(base) { base, value in
            base._hidden.accept(value)
        })
    }

}
