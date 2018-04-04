//
//  FxField.swift
//  RxSwiftForms
//
//  Created by Michael Long on 1/27/18.
//  Copyright © 2018 com.hmlong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public typealias FxKeyField = FxField<String>

/// Reactive class that manages the identity, value, and validation for a specific field or element on the form.
open class FxField<E:Hashable>: FxElement {

    // MARK: - Properties

    /// Enumeration or other hashable unique identifer for this field
    public let id: E

    /// String representation of id.
    public var key: String

    /// Field list that owns theis field.
    public weak var fields: FxFields<E>?

    // MARK: - Lifecycle

    /// Construct Field with unique identifier. Construction usually occurs in `fields.add()`.
    /// ```
    /// fields.add(.zip)
    /// ```
    public init(_ id: E) {
        self.id = id
        self.key = String(describing: id)
        super.init()

        setupValidation()
        
        #if DEBUG
            FxResourceTracking.track(ObjectIdentifier(self).hashValue, "FxField \(key)")
        #endif
    }

    deinit {
        #if DEBUG
            FxResourceTracking.release(ObjectIdentifier(self).hashValue)
        #endif
    }

    // MARK: - Internal Variables

    /// Allows access to reactive observables and binding points.
    public lazy var rx = FxFieldReactiveBase(self)

    // BehaviorRelays and not pure Observables so that FxForms can also be used with imperitive function calls
    internal lazy var _value = BehaviorRelay<FxValue>(value: FxValueNil())
    internal lazy var _error = BehaviorRelay<String?>(value: nil)

    internal lazy var _internalValidationTrigger = PublishSubject<Bool>()
    internal lazy var _externalValidationTrigger = PublishSubject<Observable<Bool>>()

    internal var _requiredRule: FxValidationRule? = nil
    internal var _validationRules = [FxValidationRule]()

}
