//
//  UISegmentedControl+Fx.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/15/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// Implements the FxBindableValue protocol for UISegmentedControl, allowing them to be bound to FxFields.
extension UISegmentedControl: FxBindableValue {
    /// Binds the field value to the control using Rx.
    public func bindFieldToView<E>(_ field: FxField<E>) -> Disposable? {
        return field.rx.int
            .asDriver(onErrorJustReturn: 0)
            .drive(rx.value)
    }
    // Binds updates to the control value back to the FxField.
    public func bindViewToField<E>(_ field: FxField<E>) -> Disposable? {
        return rx.value
            .distinctUntilChanged()
            .bind(to: field.rx.int)
    }
}
