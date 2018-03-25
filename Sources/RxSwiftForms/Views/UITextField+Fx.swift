//
//  UITextField+Binding.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/20/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// Implements the FxBindableValue protocol for UITextFields, allowing them to be bound to FxFields.
extension UITextField: FxBindableValue {
    /// Binds the field value to the view using Rx.
    public func bindFieldToView<E>(_ field: FxField<E>) -> Disposable? {
        return field.rx.text
            .asDriver(onErrorJustReturn: "")
            .drive(self.rx.text)
    }
    // Binds updates to the textfield's value back to the FxField.
    public func bindViewToField<E>(_ field: FxField<E>) -> Disposable? {
        return rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: field.rx.text)
    }
}

//extension UITextField: FxBindableKeyboard {}

//extension UITextField: FxBindablePlaceholder {}
