//
//  MetaTextErrorBackgoundColor.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/19/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

public class MetaTextErrorBackgoundColor: MetaTextBehaviorErrorHandling {

    public static let name = "MetaTextErrorBackgoundColor"

    public var name: String? { return MetaTextErrorBackgoundColor.name }
    public var priority: MetaTextPriority { return .low }

    internal weak var textField: MetaTextField?
    internal var existingColor: UIColor?
    internal let errorColor: UIColor

    init(_ errorColor: UIColor) {
        self.errorColor = errorColor
    }

    public func add(to textField: MetaTextField) -> Bool {
        self.textField = textField
        self.existingColor = textField.backgroundColor
        return true
    }

    public func handleErrorMessage(_ message: String?) {
        textField?.backgroundColor = (message?.isEmpty ?? true) ? existingColor : errorColor
    }

}
