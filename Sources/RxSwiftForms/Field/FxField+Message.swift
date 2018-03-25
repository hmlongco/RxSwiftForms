//
//  FxField+Message.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/8/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

public extension FxField {

    // MARK: - Message

    /// Defines the error message that should be returned if a validation rule fails.
    /// ```
    /// fields.add("zip").required().message("Zip code is required")
    /// ```
    /// Note that this message overrides any individual validation rule messages.
    ///
    /// - Parameter: String to display or nil to reset.
    /// - Returns: Self for further configuration.
    @discardableResult
    public func message(_ message: String?) -> FxField {
        updateAttribute(message, forkey: FxAttribute.MESSAGE)
        return self
    }

    /// Gets and sets current message value. Setting may propagate value to bound views.
    public var message: String? {
        get { return attributes[FxAttribute.MESSAGE] }
        set { updateAttribute(newValue, forkey: FxAttribute.MESSAGE) }
    }

}
