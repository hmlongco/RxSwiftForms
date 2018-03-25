//
//  FxField+Placeholder.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/8/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

//
// Considering non-reactive binding attributes
//
//protocol FxBindablePlaceholder {
//    var placeholder: String? { get set }
//}

public extension FxField {

    // MARK: - Placeholder
    
    /// Defines the placeholder value that will be passed to the bound textfield.
    /// ```
    /// fields.add("zip").placeholder("00000-0000")
    /// ```
    /// This value will not be automatically bound to view or control unless this method is called during the field definition
    /// phase prior to field binding.
    ///
    /// - Parameter string: String.
    /// - Returns: Self for further configuration.
    @discardableResult
    public func placeholder(_ string: String?) -> FxField {
//
// Considering non-reactive binding attributes
//
//        if view == nil {
//            // use protocol binding strategy binding value to view
//            addAttributeBindingStrategy(FxAttribute.PLACEHOLDER)  { (view, value) in
//                if var bindable = view as? FxBindablePlaceholder, let placeholder = value as? String {
//                    bindable.placeholder = placeholder
//                }
//            }
//        }
        placeholder = string
        return self
    }

    public var placeholder: String? {
        get { return attributes[FxAttribute.PLACEHOLDER] }
        set { updateAttribute(newValue, forkey: FxAttribute.PLACEHOLDER) }
    }

}
