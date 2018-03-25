//
//  FxForm+Auto.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/26/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension FxForm {

    // MARK: - Automatated Binding

    /// Performs automated binding of managed fields and views.
    ///
    /// This method walks the list of managed fields and searches the view controller's IBOutlets for views whose names
    /// match `field.key + suffix`.
    ///
    /// If found, the field is automatically bound to that view.
    /// ```
    /// form.autoBind()
    /// ```
    /// Note that tab order is controlled by IBOutlet order in the UIViewController.
    ///
    /// If a different order is required use `autoBind(ids:suffix:custom)` or bind fields to views manually.
    ///
    /// - Parameters:
    ///   - suffix: String appended to `field.key` for automated matching.
    ///   - custom: Optional function which allows custom bindings and/or controlling which bindings are performed automatically.
    /// - Returns: Self for further customization.
    @discardableResult
    public func autoBind(_ suffix: String = "Field", _ custom: ((FxField<E>) -> [FxFieldBindings])? = nil) -> FxForm<E> {
        guard tabOrder.isEmpty else {
            fatalError("No other bindings permitted before autoBinding.")
        }
        var initialOrder = [(field: FxField<E>, order: Int, view: UIView)]()
        for field in fields {
            let interfaceKey = field.key + suffix
            if let o = _viewControllerProperties[interfaceKey], let view: UIView = findViewControllerElement(interfaceKey) {
                initialOrder.append((field: field, order: o, view: view))
            }
        }
        initialOrder.sort { (lhs, rhs) -> Bool in lhs.order < rhs.order }
        // now bind and add field in proper order
        for item in initialOrder {
            self.bind(item.field.id, item.view, custom)
        }
        return self
    }

    /// Performs semi-auotmatic binding of specified fields and views.
    ///
    /// This method finds the matching field for each provided id, then searches the view controller's IBOutlets for views
    /// whose names match `field.key + suffix`.
    ///
    /// If found, the field is automatically bound to that view.
    /// ```
    /// form.autoBind(ids: [.firstname, .lastname])
    /// ```
    /// The list order will be the tab order.
    ///
    /// - Parameters:
    ///   - suffix: String appended to `field.key` for automated matching.
    ///   - custom: Optional function which allows custom bindings and/or controlling which bindings are performed automatically.
    /// - Returns: Self for further customization.
    @discardableResult
    public func autoBind(ids: [E], _ suffix: String = "Field", _ custom: ((FxField<E>) -> [FxFieldBindings])? = nil) -> FxForm<E> {
        guard tabOrder.isEmpty else {
            fatalError("No other bindings permitted before autoBinding.")
        }
        for id in ids {
            if let key = fields[id]?.key, _viewControllerProperties[key + suffix] != nil {
                if let view: UIView = findViewControllerElement(key + suffix) {
                    self.bind(id, view, custom)
                }
            }
        }
        return self
    }

    /// Convenience function to automatically change the background color of bound fields if those fields are invalid.
    /// ```
    /// form.autoBind()
    ///     .autoBindErrorColors()
    /// ```
    /// Methods like this one are useful, but exist more to show what can be done with Rx and a list of managed fields and views.
    /// - Parameter errorColor: New background error colors
    /// - Returns: Self for further customization.
    @discardableResult
    public func autoBindErrorColors(_ errorColor: UIColor = UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 1.0)) -> FxForm<E>  {
        guard !tabOrder.isEmpty else {
            fatalError("autoBindErrorColors may only be called after all fields are bound")
        }
        for field in fields where field.view is UITextField {
            field.updateAttribute(field.view?.backgroundColor, forkey: FxAttribute.BGCOLOR)
            field.rx.isValid
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak field] valid in
                    let color = valid ? field?.attributes[FxAttribute.BGCOLOR] : errorColor
                    if let view = field?.view, view.backgroundColor != color {
                        view.backgroundColor = color
                    }
                })
                .disposed(by: _disposeBag)
        }
        return self
    }

    /// Convenience function to automatically hide the superviews of fields that are hidden.
    /// ```
    /// form.autoBind()
    ///     .autoBindIsHiddenToSuperviews()
    /// ```
    /// If, for example, your fields are in views with an accompanying label, doing `field.isHidden = true` would hide the bound view's parent,
    /// hiding both the field and its label.
    ///
    /// Methods like this one are useful, but exist more to show what can be done with Rx and a list of managed fields and views.
    ///
    /// Note: Bind all fields **before** calling this method.
    ///
    /// - Returns: Self for further customization.
    @discardableResult
    public func autoBindIsHiddenToSuperviews() -> FxForm<E> {
        guard !tabOrder.isEmpty else {
            fatalError("autoBindIsHiddenToSuperviews may only be called after all fields are bound")
        }
        fields.forEach { self.bindIsHidden($0.id, $0.view?.superview) }
        return self
    }

    /// Convenience function to automatically bind field titles to specfic labels.
    /// ```
    /// form.autoBind()
    ///     .autoBindTitles()
    /// ```
    /// This method walks through the list of managed fields and searches the view controller's IBOutlets for labels whose names
    /// match `field.key + suffix`.'
    ///
    /// Methods like this one are useful, but exist more to show what can be done with Rx and a list of managed fields and views.
    ///
    /// Note: Bind all fields **before** calling this method.
    ///
    /// - Returns: Self for further customization.
    @discardableResult
    public func autoBindTitles(_ suffix: String = "Label") -> FxForm<E> {
        guard !tabOrder.isEmpty else {
            fatalError("autoBindTitles may only be called after all fields are bound")
        }
        for field in fields {
            if let label: UILabel = findViewControllerElement(field.key + suffix) {
                bindTitle(field.id, label)
            }
        }
        return self
    }

    /// Convenience function to automatically tab to the next field when a field's max width is reached and the field is valid.
    /// ```
    /// form.autoBind()
    ///     .autoNext()
    /// ```
    /// This is useful for text entry when the field length is fixed, like a credit card expiration date (12/2014).
    ///
    /// Note: Bind all fields **before** calling this method.
    ///
    /// - Returns: Self for further customization.
    @discardableResult
    public func autoNext() -> FxForm<E>  {
        guard !tabOrder.isEmpty else {
            fatalError("autoNext may only be called after all fields are bound")
        }
        for field in fields where field.maxLength > 0 {
            field.rx.isChanged
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    if field.asText.count >= field.maxLength && field.checkValidation() == nil {
                        self?.tabNext()
                    }
                })
                .disposed(by: _disposeBag)
        }
        return self
    }

}
