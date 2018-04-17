//
//  MetaTextErrorTextColor.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/19/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

open class MetaTextErrorTextColor: MetaTextBehaviorErrorHandling {

    public static let name = "MetaTextErrorTextColor"

    public var name: String? { return MetaTextErrorTextColor.name }
    public var priority: MetaTextPriority { return .low }

    internal weak var textField: MetaTextField?
    internal var existingColor: UIColor?
    internal let errorColor: UIColor

    public init(_ errorColor: UIColor) {
        self.errorColor = errorColor
    }

    public func add(to textField: MetaTextField) -> Bool {
        self.textField = textField
        self.existingColor = textField.textColor
        return true
    }

    public func handleErrorMessage(_ message: String?) {
        textField?.textColor = (message?.isEmpty ?? true) ? existingColor : errorColor
    }

}
