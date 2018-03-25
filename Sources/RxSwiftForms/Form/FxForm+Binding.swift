//
//  FxForm+Binding.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/21/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension FxForm {

    // MARK: - Binding

    /// Core function used to bind specific FxField's to specific views.
    /// ```
    /// form.bind(.state, .stateTextField)
    ///     .bind(.zip, zipCodeTextField)
    ///     .bind(.text, displayTextField) { _ in return [.viewToField, .error] }
    /// ```
    /// Field values are automatially bound to textfields and other controls using the `FxBindableValue` protocol.
    ///
    /// Note that the order in which fields are bound controls the tab order.
    ///
    /// - Parameters:
    ///   - id: Id of FxField to bind.
    ///   - view: Textfield or other control to bind to specified FxField.
    ///   - custom: Optional function which allows custom bindings and/or controlling which bindings are performed automatically.
    /// - Returns: Self for additonal bindings or configuration.
    @discardableResult
    public func bind(_ id: E, _ view: UIView, _ custom: ((FxField<E>) -> [FxFieldBindings])? = nil) -> FxForm<E> {
        if let field = fields[id] {
            // assign reference
            field.view = view
            // binding
            if let custom = custom {
                field.performBindings(custom(field))
            } else {
                field.performBindings()
            }
            // add to tab order
            setupTabbedElement(field, view)
        }
        return self
    }

    /// Convenience method to bind the specified FxField's error message to a specfifc label.
    /// ```
    /// form.autoBind()
    ///     .bindError(.zip, zipErrorLabel)
    /// ```
    /// - Parameters:
    ///   - id: Id of FxField to bind.
    ///   - label: UILabel to receive message.
    /// - Returns: Self for additonal bindings or configuration.
    @discardableResult
    public func bindErrorMessage(_ id: E, _ label: UILabel?) -> FxForm<E> {
        if let field = fields[id], let label = label {
            field.bindErrorMessage(label)
        }
        return self
    }

    /// Convenience method to bind the specified FxField's isEnabled flag to a specfifc control.
    /// ```
    /// form.autoBind()
    ///     .bindIsEnabled(.zip, zipTextField)
    /// ```
    /// - Parameters:
    ///   - id: Id of FxField to bind.
    ///   - label: Control to receive flag.
    /// - Returns: Self for additonal bindings or configuration.
    @discardableResult
    public func bindIsEnabled(_ id: E, _ view: UIView?) -> FxForm<E> {
        if let field = fields[id], let control = view as? UIControl {
            field.bindIsEnabled(control)
        }
        return self
    }

    /// Convenience method to bind the specified FxField's isHidden flag to a specfifc view.
    /// ```
    /// form.autoBind()
    ///     .bindIsHidden(.zip, zipStackView)
    /// ```
    /// - Parameters:
    ///   - id: Id of FxField to bind.
    ///   - label: View to receive flag.
    /// - Returns: Self for additonal bindings or configuration.
    @discardableResult
    public func bindIsHidden(_ id: E, _ view: UIView?) -> FxForm<E> {
        if let field = fields[id], let view = view {
            field.bindIsHidden(view)
        }
        return self
    }

    /// Convenience method to bind the specified FxField's title to a specfifc label.
    /// ```
    /// form.autoBind()
    ///     .bindTitle(.zip, zipLabel)
    /// ```
    /// - Parameters:
    ///   - id: Id of FxField to bind.
    ///   - label: UILabel to receive title.
    /// - Returns: Self for additonal bindings or configuration.
    @discardableResult
    public func bindTitle(_ id: E, _ label: UILabel?) -> FxForm<E> {
        if let field = fields[id], let label = label {
            field.bindTitle(label)
        }
        return self
    }

    /// Convenience method to bind the specified FxField's value to a specfifc button.
    /// ```
    /// form.autoBind()
    ///     .bindValue(.zip, zipLabel)
    /// ```
    /// - Parameters:
    ///   - id: Id of FxField to bind.
    ///   - label: UILabel to receive title.
    /// - Returns: Self for additonal bindings or configuration.
    @discardableResult
    public func bindValue(_ id: E, _ button: UIButton?) -> FxForm<E> {
        if let field = fields[id], let button = button {
            field.bindValue(button)
        }
        return self
    }

    /// Convenience method to bind the specified FxField's value to a specfifc label.
    /// ```
    /// form.autoBind()
    ///     .bindValue(.zip, zipLabel)
    /// ```
    /// - Parameters:
    ///   - id: Id of FxField to bind.
    ///   - label: UILabel to receive title.
    /// - Returns: Self for additonal bindings or configuration.
    @discardableResult
    public func bindValue(_ id: E, _ label: UILabel?) -> FxForm<E> {
        if let field = fields[id], let label = label {
            field.bindValue(label)
        }
        return self
    }

}
