//
//  FxForm+Validation.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/20/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

public extension FxForm {

    /// Sets up fields to automatically validate when any change is made.
    /// - Returns: Self for further configuration.
    @discardableResult
    public func autoValidateOnChange() -> FxForm<E> {
        for field in fields {
            field.setValidationTrigger(field.rx.isChanged)
        }
        return self
    }

    /// Sets up fields to automatically validate when user leaves its associated textfield or any change is made.
    /// - Returns: Self for further configuration.
    @discardableResult
    public func autoValidateOnChangeOrExit() -> FxForm<E> {
        for field in fields {
            let trigger = NotificationCenter.default.rx.notification(Notification.Name.UITextFieldTextDidEndEditing)
                .observeOn(MainScheduler.instance)
                .filter { [weak field] in
                    (field?.view ?? nil) == $0.object as? UIView
                }
                .map { _ in true }
            field.setValidationTrigger(Observable.merge(trigger, field.rx.isChanged))
        }
        return self
    }

    /// Sets up fields to automatically validate when user leaves its associated textfield.
    /// - Returns: Self for further configuration.
    @discardableResult
    public func autoValidateOnExit() -> FxForm<E> {
        for field in fields {
            let trigger = NotificationCenter.default.rx.notification(Notification.Name.UITextFieldTextDidEndEditing)
                .observeOn(MainScheduler.instance)
                .filter { [weak field] in
                    (field?.view ?? nil) == $0.object as? UIView
                }
                .map { _ in true }
            field.setValidationTrigger(trigger)
        }
        return self
    }

    public func isValid() -> Bool {
        return fields.isValid()
    }

}
