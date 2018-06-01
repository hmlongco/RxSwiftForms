//
//  FxField+Binding.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/10/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public enum FxFieldBindings {
    case fieldToView
    case viewToField
    case error
    case attributes

    var all: [FxFieldBindings] { return [.fieldToView, .viewToField, .error, .attributes] }
}

extension FxField {

    // MARK: - Binding

    /// Called from FxForm.bind() to perform standard value, error, and attribute bindings to the previously assigned view.
    ///
    /// Note: Users should not need to call this function themselves.
    ///
    /// - Parameter exclusions: List of bindings already handled by user and that should **not** be performed.
    public func performBindings(_ exclusions: [FxFieldBindings] = []) {
        if !exclusions.contains(.fieldToView) {
            performFieldToViewBinding()
        }
        if !exclusions.contains(.viewToField) {
            performViewToFieldBinding()
        }
        if !exclusions.contains(.error) {
            performErrorBinding()
        }
        if !exclusions.contains(.attributes) {
            performAttributeBinding()
        }
    }

    /// Convenience method to bind our error message to a specfifc label.
    /// ```
    /// bindErrorMessage(label)
    /// ```
    /// - Parameters:
    ///   - label: UILabel to receive message.
    /// - Returns: Self for additonal bindings or configuration.
    public func bindErrorMessage(_ label: UILabel?) {
        if let label = label {
            rx.errorMessage
                .observeOn(MainScheduler.instance)
                .bind(to: label.rx.text)
                .disposed(by: _disposeBag)
        }
    }

    /// Convenience method to bind our isEnabled flag to a specfifc control.
    /// ```
    /// field.bindIsEnabled(.zipTextField)
    /// ```
    /// - Parameters:
    ///   - label: Control to receive flag.
    /// - Returns: Self for additonal bindings or configuration.
    public func bindIsEnabled(_ view: UIView?) {
        if let control = view as? UIControl {
            rx.isEnabled
                .observeOn(MainScheduler.instance)
                .bind(to: control.rx.isEnabled)
                .disposed(by: _disposeBag)
        }
    }

    /// Convenience method to bind our isHidden flag to a specfifc view.
    /// ```
    /// field.bindIsHidden(.zipTextField)
    /// ```
    /// - Parameters:
    ///   - id: Id of FxField to bind.
    ///   - label: View to receive flag.
    /// - Returns: Self for additonal bindings or configuration.
    public func bindIsHidden(_ view: UIView?) {
        if let view = view {
            rx.isHidden
                .observeOn(MainScheduler.instance)
                .bind(to: view.rx.isHidden)
                .disposed(by: _disposeBag)
        }
    }

    /// Convenience method to bind our title to a specfifc label.
    /// ```
    /// form.autoBind()
    ///     .bindTitle(.zip, zipLabel)
    /// ```
    /// - Parameters:
    ///   - id: Id of FxField to bind.
    ///   - label: UILabel to receive title.
    /// - Returns: Self for additonal bindings or configuration.
    public func bindTitle(_ label: UILabel?) {
        if let label = label {
            rx.title
                .observeOn(MainScheduler.instance)
                .bind(to: label.rx.text)
                .disposed(by: _disposeBag)
        }
    }

    /// Convenience method to bind our value to a specfifc button title.
    /// ```
    /// form.autoBind()
    ///     .bindValue(.zip, myButton)
    /// ```
    /// - Parameters:
    ///   - id: Id of FxField to bind.
    ///   - label: UILabel to receive title.
    /// - Returns: Self for additonal bindings or configuration.
    public func bindValue(_ button: UIButton?) {
        if let button = button {
            rx.text
                .observeOn(MainScheduler.instance)
                .bind(to: button.rx.title())
                .disposed(by: _disposeBag)
        }
    }

    /// Convenience method to bind our value to a specfifc label.
    /// ```
    /// form.autoBind()
    ///     .bindTitle(.zip, zipLabel)
    /// ```
    /// - Parameters:
    ///   - id: Id of FxField to bind.
    ///   - label: UILabel to receive title.
    /// - Returns: Self for additonal bindings or configuration.
    public func bindValue(_ label: UILabel?) {
        if let label = label {
            rx.text
                .observeOn(MainScheduler.instance)
                .bind(to: label.rx.text)
                .disposed(by: _disposeBag)
        }
    }

    // MARK: - Internal Functions

    internal func performFieldToViewBinding() {
        if let bindable = view as? FxBindableValue {
            bindable.bindFieldToView(self)?.disposed(by: _disposeBag)
        }
    }

    internal func performViewToFieldBinding() {
        if let bindable = view as? FxBindableValue {
            bindable.bindViewToField(self)?.disposed(by: _disposeBag)
        }
    }

    internal func performErrorBinding() {
        guard hasValidationRules else {
            return
        }
        guard let view = view else {
            return
        }
        rx.errorMessage
            .asDriver(onErrorJustReturn: nil)
            .drive(view.rx.fxErrorMessage)
            .disposed(by: _disposeBag)
    }

}
