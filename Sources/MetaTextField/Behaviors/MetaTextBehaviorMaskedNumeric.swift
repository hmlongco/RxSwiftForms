//
//  MetaTextBehaviorMaskedNumeric.swift
//  RxSwiftForms
//
//  Created by Michael Long on 6/29/17.
//  Copyright © 2017 Client Resources Inc. All rights reserved.
//

import UIKit

public class MetaTextBehaviorMaskedNumeric: MetaTextBehaviorChanging {

    public static let name = "MetaTextBehaviorMaskedNumeric"

    public var name: String? { return MetaTextBehaviorMaskedNumeric.name }
    public var priority: MetaTextPriority { return .medium }

    public var maskFormat: String?

    public init(_ maskFormat: String?) {
        self.maskFormat = maskFormat
    }

    public func add(to textField: MetaTextField) -> Bool {
        return true
    }

    public func shouldChangeText(_ textField: UITextField, _ range: NSRange, _ string: String) -> Bool? {

        let oldText = (textField.text ?? "")
        let newText = (oldText as NSString).replacingCharacters(in: range, with: string)

        // masking
        if let mask = maskFormat, !mask.isEmpty {
            let maskedText = formatDigitsWith(newText, using: mask)
            if maskedText != oldText as String {
                textField.text = maskedText
                let offsetFromEndOfLine = oldText.count - (range.location + range.length)
                if let position = textField.position(from: textField.endOfDocument, offset: -offsetFromEndOfLine) {
                    textField.selectedTextRange = textField.textRange(from: position, to: position)
                }
                textField.sendActions(for: .editingChanged)
            }
            return false
        }

        return nil
    }

    internal func formatDigitsWith(_ string: String, using mask: String) -> String {
        let cleanNumber = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var index = cleanNumber.startIndex
        for ch in mask {
            if index == cleanNumber.endIndex {
                break
            }
            if ch == "9" {
                result.append(cleanNumber[index])
                index = cleanNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }

}
