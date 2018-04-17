//
//  FxFields+Validation.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/20/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

public extension FxFields {

    /// Clears all field errors.
    public func clearErrors() {
        list.forEach { $0.clearError() }
    }

    /// Returns the validation state of all managed fields, and sets field validation state accordingly.
    /// ```
    /// if fields.isValid() {
    ///     save()
    /// }
    /// ```
    @discardableResult
    public func isValid() -> Bool {
        return list.reduce(true) { $1.isValid() && $0 }
    }

    /// Returns the validation state of all managed fields. Does not trigger field error messages.
    /// ```
    /// if fields.checkValidation() {
    ///     save()
    /// }
    /// ```
    @discardableResult
    public func checkValidation() -> Bool {
        return list.reduce(true) { ($1.checkValidation() == nil) && $0 }
    }

    /// Returns a list of all managed fields with errors.
    /// ```
    /// for badField in fields.errorFields() { ... }
    /// ```
    public var errorFields: [FxField<E>] {
        return list.filter { $0.error != nil }
    }

    /// Returns a list of error messages for all invalid fields.
    /// ```
    /// for message in fields.errorMessages() { ... }
    /// ```
    public var errorMessages: [String] {
        return errorFields.map { $0.error ?? "" }
    }

    /// Returns a formatted string of error messages for all invalid fields.
    /// ```
    /// let errors = fields.errorMessagesAsString()
    /// showErrorMessage("Errors:\n" + errors)
    /// ```
    public func errorMessagesAsString(separatedBy separator:String = "\n") -> String {
        return errorMessages
            .reduce("") { "\($0)\(separator)\($1)" }
            .trimmingCharacters(in: CharacterSet(charactersIn: "\n"))
    }

}
