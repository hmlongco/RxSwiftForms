//
//  FxCheckbox.swift
//  FoxProject
//
//  Created by Michael Long on 2/21/17.
//  Copyright © 2017 com.hmlong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable

open class FxCheckbox: UIButton {

    @IBInspectable public var isChecked: Bool {
        get {
            return _checked.value
        }
        set {
            _checked.accept(newValue)
            let text = newValue ? checkedText : uncheckedText
            setTitle(text, for: .normal)
        }
    }

    @IBInspectable var checkedText: String = "\u{2612}"
    @IBInspectable var uncheckedText: String = "\u{2610}"

    fileprivate var _checked = BehaviorRelay(value: false)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }

    public func initCommon() {
        addTarget(self, action: #selector(touched(_:)), for: .touchUpInside)
        setTitle(uncheckedText, for: .normal)
    }

    @objc
    public func touched(_ sender:AnyObject) {
        toggleState()
    }

    public func toggleState() {
        isChecked = !isChecked
    }

    override open func prepareForInterfaceBuilder() {
        setTitle(uncheckedText, for: .normal)
    }
}

/// Implements the Reactive protocol for FxCheckbox, allowing them to be bound to FxFields.
///
/// Field value is bound to the button's `isSelected` property.
extension Reactive where Base: FxCheckbox {

    /// Boolean value for observables and binding.
    public var isChecked: ControlProperty<Bool> {
        let value = base._checked
            .distinctUntilChanged()
            .share()
        return ControlProperty(values: value, valueSink: Binder(base) { base, value in
            base._checked.accept(value)
        })
    }

}

/// Implements the FxBindableValue protocol for FxCheckbox, allowing them to be bound to FxFields.
///
/// Field value is bound to the button's `isSelected` property.
extension FxCheckbox: FxBindableValue {
    /// Binds the field value to the control using Rx.
    public func bindFieldToView<E>(_ field: FxField<E>) -> Disposable? {
        return field.rx.bool
            .asDriver(onErrorJustReturn: false)
            .drive(rx.isChecked)
    }
    /// Binds updates to the control value back to the FxField.
    public func bindViewToField<E>(_ field: FxField<E>) -> Disposable? {
        return rx.isChecked
            .bind(to: field.rx.bool)
    }
}
