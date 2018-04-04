//
//  FxFields.swift
//  RxSwiftForms
//
//  Created by Michael Long on 1/21/18.
//  Copyright © 2018 com.hmlong. All rights reserved.
//

import RxSwift
import RxCocoa

public typealias FxKeyFields = FxFields<String>

/// Reactive class that manages a list of FxFields.
open class FxFields<E:Hashable>: FxBase, Sequence {

    // MARK: - FxFields Properties

    public var list = [FxField<E>]()
    public var map = [String : FxField<E>]()

    // MARK: - FxFields Lifecycle

    override public init() {
        super.init()
        setupObservables()
        
        #if DEBUG
            FxResourceTracking.track(ObjectIdentifier(self).hashValue, "FxFields")
        #endif
    }

    deinit {
        #if DEBUG
            FxResourceTracking.release(ObjectIdentifier(self).hashValue)
        #endif
    }

    // MARK: - Rx Functionality

    /// Allows access to reactive observables and binding points.
    public lazy var rx = FxFieldsReactiveBase(self)

    internal var _changed: Observable<Bool>!
    internal var _valid: Observable<Bool>!
    internal var _validation: ((_ fields: FxFields<E>) -> String?)?

    // MARK: - FxFields Functionality

    /// Clears all managed field values.
    public func clear() {
        list.forEach { $0.clear() }
    }

    // MARK: - FxField Functionality

    /// Constructs a FxField with the specified id and adds it to the list of managed fields.
    /// ```
    /// fields.add(.zip).required()
    /// ```
    /// - Parameter id: Unique id of field to add.
    /// - Returns: FxField for further configuration.
    @discardableResult
    public func add(_ id: E) -> FxField<E> {
        return add(FxField(id))
    }

    /// Adds field to the list of managed fields.
    /// ```
    /// let field = FxField<E>(ContactFields.zip)
    /// fields.add(field).required()
    /// ```
    /// - Parameter field: FxField to add.
    /// - Returns: FxField for further configuration.
    @discardableResult
    public func add(_ field: FxField<E>) -> FxField<E> {
        guard map[field.key] == nil else {
            fatalError("Field with key '\(field.key)' already added.")
        }
        list.append(field)
        map[field.key] = field
        field.fields = self
        return field
    }

    // MARK: - Subscripting

    /// Returns FxField<E> with the given id.
    public subscript(_ id: E) -> FxField<E>? {
        get {
            return map["\(id)"]
        }
    }

    // MARK: - Sequencing

    /// Returns iterator that will sequence through all managed FxField<E>'s.
    public func makeIterator() -> FxFieldsIterator<E> {
        return FxFieldsIterator<E>(self)
    }

}

public struct FxFieldsIterator<E:Hashable>: IteratorProtocol {
    let fields: [FxField<E>]
    var index = 0

    init(_ fields: FxFields<E>) {
        self.fields = fields.list
    }

    mutating public func next() -> FxField<E>? {
        guard index < fields.count else { return nil }
        let field = fields[index]
        index += 1
        return field
    }
}
