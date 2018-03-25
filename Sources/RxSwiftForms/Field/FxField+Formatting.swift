//
//  FxTransforming.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/8/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation

public extension FxField {

    // MARK: - Formatting
    
    /// Defines text formatter to be used for `rx.text` binding.
    /// ```
    /// fields.add(.state).format(FxTextFormatUppercased())
    /// ```
    /// - Parameter formatter: FxTextFormatting-based text formatter.
    /// - Returns: Self for further configuration.
    @discardableResult
    public func format(_ formatter: FxTextFormatting?) -> FxField {
        guard view == nil else {
            return self
        }
        self.formatter = formatter
        return self
    }

    /// Gets and sets current formatter.
    public var formatter: FxTextFormatting? {
        get { return attributes[FxAttribute.FORMATTER] }
        set { updateAttribute(newValue, forkey: FxAttribute.FORMATTER) }
    }

    /// Returns the field's current value as formatted text.
    public var asFormattedText: String {
        let text = asText
        return formatter?.string(from: text) ?? text
    }

}
