//
//  FxField+Keyboard.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/8/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

//
// Considering non-reactive binding attributes
//
//public protocol FxBindableKeyboard {
//    var keyboardType: UIKeyboardType { get set }
//}

public extension FxField {

    // MARK: - Keyboard

    /// Defines keyboard type for later binding to textfield.
    /// ```
    /// fields.add("zip").keyboard(.numberpad)
    /// ```
    /// Note value will not be automatically bound to view or control unless this method is called during the field definition
    /// phase prior to field binding.
    ///
    /// - Returns: Self for further configuration.
    @discardableResult
    public func keyboardType(_ type: UIKeyboardType?) -> FxField {
//
// Considering non-reactive binding attributes
//
//        if view == nil {
//            // use type-based protocol binding strategy binding value to view
//            addAttributeBindingStrategy(FxAttribute.KEYBOARD)  { (view, value) in
//                if var bindable = view as? FxBindableKeyboard, let type = value as? UIKeyboardType {
//                    bindable.keyboardType = type
//                }
//            }
//        }
        keyboardType = type
        return self
    }

    /// Gets and sets current keyboard value. Setting may propagate value to bound views.
    public var keyboardType: UIKeyboardType? {
        get { return attributes[FxAttribute.KEYBOARD] }
        set { updateAttribute(newValue, forkey: FxAttribute.KEYBOARD) }
    }

}
