//
//  MetaTextBehaviorMaxLength.swift
//  RxSwiftForms
//
//  Created by Michael Long on 7/19/17.
//  Copyright © 2017 Client Resources Inc. All rights reserved.
//

import UIKit

public class MetaTextBehaviorMaxLength: MetaTextBehaviorChanging {

    public static let name = "MetaTextBehaviorMaxLength"

    public var name: String? { return MetaTextBehaviorMaxLength.name }
    public var priority: MetaTextPriority { return .mediumHigh }

    public var maxWidth: Int = 0

    public init(_ maxWidth: Int) {
        self.maxWidth = maxWidth
    }

    public func add(to textField: MetaTextField) -> Bool {
        return true
    }

    public func shouldChangeText(_ textField: UITextField, _ range: NSRange, _ string: String) -> Bool? {
        let oldText = (textField.text ?? "")
        let newText = (oldText as NSString).replacingCharacters(in: range, with: string)

        if maxWidth > 0 && newText.count > maxWidth {
            return false
        }

        return nil
    }

}
