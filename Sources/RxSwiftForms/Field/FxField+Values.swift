//
//  FxFieldValues.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/12/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol FxBindableValue {
    func bindFieldToView<E>(_ field: FxField<E>) -> Disposable?
    func bindViewToField<E>(_ field: FxField<E>) -> Disposable?
}

public extension FxField {

    // MARK: - Values

    /// Sets initial value of field. Value will be bound to view or control by FxForm.
    /// ```
    /// fields.add(.amount).value(contact.amount)
    /// fields.add(.zip).value(contact.zip)
    /// fields.add(.message).value("This is a message.")
    /// fields.add(.agrees).value(false)
    /// ```
    /// - Parameter value: Value of type T.
    /// - Returns: Self for further configuration.
    @discardableResult
    public func value<T>(_ value: T?) -> FxField {
        _value.accept(FxValues.make(value))
        return self
    }

    /// Generic function returns current value as? type T. If T is unknown type returned value will be nil.
    public func value<T>() -> T? {
        return _value.value.asType()
    }

    /// Clears the current value.
    public func clear() {
        var typedValue = _value.value
        typedValue.reset()
        _value.accept(typedValue)
        clearError()
    }

    // MARK: - Value Conversions

    /// Returns true if current value is empty.
    public var isEmpty: Bool { return _value.value.isEmpty }

    /// Returns current value as Bool.
    public var asBool: Bool {
        return _value.value.asBool
    }

    /// Returns current value as Bool or nil if value is false.
    public var asOptionalBool: Bool? {
        return _value.value.isEmpty ? nil : _value.value.asBool
    }

    /// Returns current value as Double.
    public var asDouble: Double {
        return _value.value.asDouble
    }

    /// Returns current value as Double or nil if value is empty.
    public var asOptionalDouble: Double? {
        return _value.value.isEmpty ? nil : _value.value.asDouble
    }

    /// Returns current value as Int.
    public var asInt: Int {
        return _value.value.asInt
    }

    /// Returns current value as Int or nil if value is empty.
    public var asOptionalInt: Int? {
        return _value.value.isEmpty ? nil : _value.value.asInt
    }

    /// Returns current value as String.
    public var asText: String {
        return _value.value.asText
    }

    /// Returns current value as String or nil if value is empty.
    public var asOptionalText: String? {
        return _value.value.isEmpty ? nil : _value.value.asText
    }

}
