//
//  FxFieldValidation.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/1/18.
//  Copyright © 2018 com.hmlong. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

// MARK: - Validation Types

public extension FxField {

    // MARK: - Validation

    /// Adds the specified validation rule to the set of field validation rules.
    /// ```
    /// fields.add("zip").validate(FxRules.zipcode)
    /// ```
    /// Validation rules are only checked when field values are not empty. Use `.required()` to force validation to occur.
    ///
    /// - Parameter rule: FxValidationRule.
    /// - Returns: Self for further configuration.
    @discardableResult
    public func validate(_ rule: FxValidationRule) -> FxField {
        removeValidationRule(rule.name)
        _validationRules.append(rule)
        return self
    }

    /// Constructs and adds an unnamed validation rule to the set of field validation rules.
    /// ```
    /// fields.add("zip").validate(errorZip) { $0.asText.count == 5 || $0.asText.count == 10 }
    /// ```
    /// Validation fuctions are only checked when field values are not empty. Use `.required()` to force validation to occur.
    ///
    /// - Parameter message: Optional custom error message for this rule.
    /// - Parameter valid: Validation function or closure. Returns true if value is valid.
    /// - Returns: Self for further configuration.
    @discardableResult
    public func validate(_ message: String? = nil, _ valid: @escaping FxFieldValidationFunction) -> FxField {
        let rule = FxStandardValidationRule("", message: message, valid: valid)
        return validate(rule)
    }

    /// Constructs and adds the specified validation rule to the set of field validation rules.
    /// ```
    /// fields.add("zip").validate(name: "zip", message: errorZip) { $0.asText.count == 5 || $0.asText.count == 10 }
    /// ```
    /// Validation fuctions are only checked when field values are not empty. Use `.required()` to force validation to occur.
    ///
    /// - Parameter name: Rules with names allow resetting/changing rules.
    /// - Parameter message: Optional custom error message for this rule.
    /// - Parameter valid: Validation function or closure. Returns true if value is valid.
    /// - Returns: Self for further configuration.
    @discardableResult
    public func validate(name: String, message: String? = nil, _ valid: @escaping FxFieldValidationFunction) -> FxField {
        let rule = FxStandardValidationRule(name, message: message, valid: valid)
        return validate(rule)
    }

    /// Returns true if required rule or validation rules exist.
    public var hasValidationRules: Bool {
        return isRequired || !_validationRules.isEmpty
    }

    /// Removes all validation rules.
    public func removeAllValidationRules() {
        _validationRules = []
    }

    /// Removes the named rule from the list of validation rules.
    public func removeValidationRule(_ name: String) {
        if !_validationRules.isEmpty, !name.isEmpty {
            _validationRules = _validationRules.filter { $0.name != name }
        }
    }

    /// Returns true if field is valid and all validation rules passed.
    ///
    /// Note: Calling isValid will set or clear the field error message value based on validation success.
    @discardableResult
    public func isValid() -> Bool {
        _internalValidationTrigger.onNext(true)
        return error == nil
    }

    /// Checks all validation rules. If validation fails error message will be **returned**, not set.
    public func checkValidation() -> String? {
        return checkValidation(_value.value)
    }

    /// Validation triggers are used to fire validation rules when a given event occurs.
    /// ```
    /// field.setValidationTrigger(field.rx.isChanged)
    /// ```
    /// - Parameter trigger: Observable that fires validation rules when next event is received.
    public func setValidationTrigger(_ trigger: Observable<Bool>?) {
        if let trigger = trigger {
            _externalValidationTrigger.onNext(trigger)
        } else {
            _externalValidationTrigger.onNext(Observable.never())
        }
    }

    // MARK: - Internals

    /// Defines the reactive sequence of events that occurs when a validation trigger is fired. Gets field value, passes it to the validation
    /// routines, and binds the result to the field error message.
    ///
    /// WARNING: Correct validation behavior depends on this core functionality. Make sure you understand the impact of any changes!
    internal func setupValidation() {
        let internalTrigger = _internalValidationTrigger
            .filter { $0 }

        let externalTrigger = _externalValidationTrigger
            .switchLatest()
            .filter { $0 }

        let value = _value
            .distinctUntilChanged { $0.isEqual($1) }

        Observable<Bool>
            .merge(internalTrigger, externalTrigger)
            .withLatestFrom(value)
            .map { [weak self] (value) -> String? in
                return self?.checkValidation(value)
            }
            .bind(to: _error)
            .disposed(by: _disposeBag)
    }

    internal func checkValidation(_ value: FxValue) -> String? {
        guard hasValidationRules, isHidden == false else {
            return nil
        }
        //print("Validating: \(key) = \(value.asText)")
        if let message = checkValidationRequiredRule(value) {
            return message
        }
        if let message = checkValidationRules(value) {
            return message
        }
        return nil
    }

    internal func checkValidationRequiredRule(_ value: FxValue) -> String? {
        if let rule = _requiredRule, rule.valid(value) == false {
            return message ?? rule.message ?? "\(title ?? key.capitalized) is required."
        }
        return nil
    }

    internal func checkValidationRules(_ value: FxValue) -> String? {
        if !value.isEmpty {
            for rule in _validationRules {
                if rule.valid(value) == false  {
                    return message ?? rule.message ?? "\(title ?? key.capitalized) is invalid."
                }
            }
        }
        return nil
    }

}
