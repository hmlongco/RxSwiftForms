//
//  FxField+Required.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/8/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

// MARK: - Validation Types

public extension FxField {

    // MARK: - Required / Optional Validation

    /// Defines validation rule that the field value is optional. Will clear the Required validation rule.
    /// ```
    /// fields.add("zip").optional()
    /// ```
    /// - Returns: Self for further configuration.
    @discardableResult
    public func optional() -> FxField {
        _requiredRule = nil
        return self
    }

    /// Defines validation rule that indicates value must not be nil or empty. Will clear the Optional validation rule.
    /// ```
    /// fields.add("state").required(length: 2)
    /// fields.add("zip").required()
    /// ```
    /// - Parameter length: If specifed field must be **exactly** the length indicated.
    /// - Returns: Self for further configuration.
    @discardableResult
    public func required(length: Int = 0) -> FxField {
        if length > 0 {
            updateAttribute(length, forkey: FxAttribute.MAXLENGTH)
            updateAttribute(length, forkey: FxAttribute.MINLENGTH)
            _requiredRule = FxStandardValidationRule(FxAttribute.REQUIRED) { $0.asText.count == length }
        } else {
            _requiredRule = FxStandardValidationRule(FxAttribute.REQUIRED) { !$0.isEmpty }
        }
        return self
    }

    public var isRequired: Bool {
        return _requiredRule != nil
    }

}
