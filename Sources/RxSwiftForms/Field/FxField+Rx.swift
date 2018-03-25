//
//  FxField+Rx.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/20/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension FxField {

    /// This observable automatically fires whenever the base value is set or updated
    public func asObservable() -> Observable<FxField<E>> {
        // it also avoids the retain cycle created by adding self to a behavior subject
        // as long as the base value observable exists, [unowned self] will be valid
        return _value.asObservable().map { [unowned self] _ in return self }
    }

}

public struct FxFieldReactiveBase<E:Hashable> {

    weak var base: FxField<E>!

    init(_ base: FxField<E>) {
        self.base = base
    }

    // MARK: - Rx Observable and Bindable Properties

    /// Boolean value for observables and binding.
    public var bool: ControlProperty<Bool> {
        let value = base._value
            .map { $0.asBool }
            .distinctUntilChanged()
            .share()
        return ControlProperty(values: value, valueSink: Binder(base) { base, value in
            base._value.accept(FxValueBool(value))
        })
    }

    /// Double value for observables and binding.
    public var double: ControlProperty<Double> {
        let value = base._value
            .map { $0.asDouble }
            .distinctUntilChanged()
            .share()
        return ControlProperty(values: value, valueSink: Binder(base) { base, value in
            base._value.accept(FxValueGeneric(value))
        })
    }

    /// Integer value for observables and binding.
    public var int: ControlProperty<Int>{
        let value = base._value
            .map { $0.asInt }
            .distinctUntilChanged()
            .share()
        return ControlProperty(values: value, valueSink: Binder(base) { base, value in
            base._value.accept(FxValueGeneric(value))
        })
    }

    /// Text value for observables and binding.
    public var text: ControlProperty<String> {
        let value = base._value
            .map { $0.asText }
            .map { self.base.formatter?.string(from: $0) ?? $0 }
            .distinctUntilChanged()
            .share()
        return ControlProperty(values: value, valueSink: Binder(base) { base, value in
            base._value.accept(FxValueText(value))
        })
    }

    /// Raw FxValue value for observables and binding.
    public var value: ControlProperty<FxValue> {
        let value = base._value
            .distinctUntilChanged { $0.isEqual($1) }
            .share()
        return ControlProperty(values: value, valueSink: Binder(base) { base, value in
            base._value.accept(value)
        })
    }

    // MARK: - Rx Field Observables

    /// Oservable fires when field value is changed or updated.
    public var isChanged: Observable<Bool> {
        return base._value
            .map { _ in true }
            .share()
    }

    // MARK: - Rx Field Binders

    // Endpoint fires validation sequence on demand.
    public var validate: Binder<Void> {
        return Binder<Void>(base, binding: { (base, _) in
            base._internalValidationTrigger.onNext(true)
        })
    }

}
