//
//  FxRules.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/26/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation

public typealias FxFieldValidationFunction = (_ value: FxValue) -> Bool

public protocol FxValidationRule {
    var name: String { get }
    var message: String? { get }
    var valid: FxFieldValidationFunction { get }
}

public struct FxStandardValidationRule: FxValidationRule {
    public var name: String
    public var message: String?
    public var valid: FxFieldValidationFunction
    public init(_ name: String, message: String? = nil, valid: @escaping FxFieldValidationFunction) {
        self.name = name.uppercased()
        self.message = message
        self.valid = valid
    }
}

public class FxRules {

    public static func make(_ name: String, _ message: String?, _ valid: @escaping FxFieldValidationFunction ) -> FxValidationRule {
        return FxStandardValidationRule(name, message: message, valid: valid)
    }

    public static func creditcard(_ message: String? = nil) -> FxValidationRule {
        return make("creditcard-fxvr", message, { value in
            let pattern = "^\\b(?:3[47]\\d{2}([\\s-]?)\\d{6}\\1\\d|(?:(?:4\\d|5[1-5]|65)\\d{2}|6011)([\\s-]?)\\d{4}\\2\\d{4}\\2)\\d{4}\\b$"
            let text = value.asText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            return text.range(of: pattern, options: [.caseInsensitive, .regularExpression]) != nil
        })
    }

    public static func currency(_ message: String? = nil) -> FxValidationRule {
        return regex("currency-fxvr", "^[0-9]+(?:[\\.]*[0-9]{2})*$", message)
    }
    
    public static func cvc(_ message: String? = nil) -> FxValidationRule {
        return regex("cvc-fxvr", "^\\d{3}\\d*$", message)
    }

    public static func decimal(_ message: String? = nil) -> FxValidationRule {
        return regex("decimal-fxvr", "^[0-9]+(?:[\\.]*[0-9]*)$", message)
    }

    public static func email(_ message: String? = nil) -> FxValidationRule {
        return regex("email-fxvr", "^[A-Z0-9._%+-]+\\@[A-Z0-9.-]+\\.[A-Z]{2,6}$", message)
    }

    public static func expiresYear2(_ message: String? = nil) -> FxValidationRule {
        return regex("expiresyear2-fxvr", "^\\d{2}[/]\\d{2}$", message)
    }

    public static func expiresYear4(_ message: String? = nil) -> FxValidationRule {
        return regex("expiresyear4-fxvr", "^\\d{2}[/]\\d{4}$", message)
    }

    public static func integer(_ message: String? = nil) -> FxValidationRule {
        return regex("integer-fxvr", "^[0-9]+$", message)
    }

    public static func luhn(_ message: String? = nil) -> FxValidationRule {
        return make("luhn-fxvr", message, { value in
            let text = value.asText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            var sum = 0
            let reversedCharacters = text.reversed().map { String($0) }
            for (idx, element) in reversedCharacters.enumerated() {
                guard let digit = Int(element) else { return false }
                switch ((idx % 2 == 1), digit) {
                case (true, 9): sum += 9
                case (true, 0...8): sum += (digit * 2) % 9
                default: sum += digit
                }
            }
            return sum % 10 == 0
        })
    }

    public static func phone(_ message: String? = nil) -> FxValidationRule {
        return regex("phone-fxvr", "^[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}$", message)
    }

    public static func ssn(_ message: String? = nil) -> FxValidationRule {
        return regex("ssn-fxvr", "^\\d{3}[-]d{3}[-]d{4}$", message)
    }

    public static func regex(_ name: String?, _ pattern: String, _ message: String? = nil) -> FxValidationRule {
        return make(name ?? "regex-fxvr", message, { value in
            return value.asText.range(of: pattern, options: [.caseInsensitive, .regularExpression]) != nil
        })
    }

    public static func zipcode(_ message: String? = nil) -> FxValidationRule {
        return regex("zipcode-fxvr", "^\\d{5}$", message)
    }

    public static func zipPlusFour(_ message: String? = nil) -> FxValidationRule {
        return regex("zipplusfour-fxvr", "^\\d{5}(?:[-]\\d{4})?$", message)
    }

}
