//
//  FxField+MinLength.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/8/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

// MARK: - Validation Types

public extension FxField {

    // MARK: - Min Length Validation
    
    /// Defines validation rule that states field text values must be at least N characters long.
    /// ```
    /// fields.add("zip").min(length: 5)
    /// ```
    /// - Parameter length: Minimum length for field value or 0 to reset.
    /// - Returns: Self for further configuration.
    @discardableResult
    public func min(length: Int) -> FxField {
        updateAttribute(length, forkey: FxAttribute.MAXLENGTH)
        if length > 0 {
            return validate(name: FxAttribute.MINLENGTH) { $0.asText.count >= length }
        } else {
            removeValidationRule(FxAttribute.MINLENGTH)
            return self
        }
    }

    /// Returns current maxLength value. Changing updates the validation rule appropriately.
    public var minLength: Int {
        get { return attributes[FxAttribute.MINLENGTH] ?? 0 }
        set { min(length: newValue) }
    }

}
