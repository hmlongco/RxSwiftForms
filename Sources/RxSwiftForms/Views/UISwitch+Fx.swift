//
//  FxFieldBinding.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/1/18.
//  Copyright © 2018 com.hmlong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// Implements the FxBindableValue protocol for UISwitches, allowing them to be bound to FxFields.
extension UISwitch: FxBindableValue {
    /// Binds the field value to the control using Rx.
    public func bindFieldToView<E>(_ field: FxField<E>) -> Disposable? {
        return field.rx.bool
            .asDriver(onErrorJustReturn: false)
            .drive(rx.isOn)
    }
    // Binds updates to the control value back to the FxField.
    public func bindViewToField<E>(_ field: FxField<E>) -> Disposable? {
        return rx.isOn
            .distinctUntilChanged()
            .bind(to: field.rx.bool)
    }
}
