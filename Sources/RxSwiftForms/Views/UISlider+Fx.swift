//
//  UISlider+Fx.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/15/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// Implements the FxBindableValue protocol for UISlider, allowing them to be bound to FxFields.
extension UISlider: FxBindableValue {
    /// Binds the field value to the control using Rx.
    public func bindFieldToView<E>(_ field: FxField<E>) -> Disposable? {
        return field.rx.double
            .map { Float($0) }
            .asDriver(onErrorJustReturn: 0.0)
            .drive(rx.value)
    }
    // Binds updates to the control value back to the FxField.
    public func bindViewToField<E>(_ field: FxField<E>) -> Disposable? {
        return rx.value
            .distinctUntilChanged()
            .map { Double($0) }
            .bind(to: field.rx.double)
    }
}
