//
//  FxField+MaxWidth.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/8/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

public protocol FxBindableMaxLength {
    var maxLength: Int { get set }
}

public extension FxField {

    // MARK: - Max Length Validation
    
    /// Defines validation rule that states field text values may not be more than N characters long.
    /// ```
    /// fields.add("zip").max(length: 5)
    /// ```
    /// - Parameter length: Max length for field value or 0 to reset.
    /// - Returns: Self for further configuration.
    @discardableResult
    public func max(length: Int) -> FxField {
//
// Considering non-reactive binding attributes
//
//        if view == nil {
//            // use protocol binding strategy binding value to view
//            addAttributeBindingStrategy(FxAttribute.MAXLENGTH)  { (view, value) in
//                view?.fx.maxLength = value as? Int ?? 0
//            }
//        }
        updateAttribute(length, forkey: FxAttribute.MAXLENGTH)
        if length > 0 {
            return validate(name: FxAttribute.MAXLENGTH) { $0.asText.count <= length }
        } else {
            removeValidationRule(FxAttribute.MAXLENGTH)
            return self
        }
    }

    /// Returns current maxLength value. Changing updates the validation rule appropriately.
    public var maxLength: Int {
        get { return attributes[FxAttribute.MAXLENGTH] ?? 0 }
        set { max(length: newValue) } // update validation rule
    }

}
