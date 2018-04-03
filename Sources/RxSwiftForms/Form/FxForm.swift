//
//  RxForm.swift
//  RxSwiftForms
//
//  Created by Michael Long on 1/27/18.
//  Copyright © 2018 com.hmlong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public typealias FxKeyForm = FxForm<String>

/// Reactive class that controls binding specific FxField's to specifc views.
open class FxForm<E:Hashable> : FxBase, Sequence {

    // MARK: - FxForm Properties

    /// List of managed fields.
    public var fields: FxFields<E>!

    /// Bound fields in proper tab order.
    public var tabOrder = [FxField<E>]()

    /// UIViewController that contains the form and the @IBOutlet's to be bound to the form.
    internal weak var _viewController: UIViewController!
    internal var _viewControllerProperties: [String:Int]!

    /// Manages the scrollview and adjusts the content area for keyboard show/hide events.
    internal var _viewScroller: FxViewScrolling?

    /// Supports keyboard hiding gestures.
    internal var _hideKeyboardGesture: FxHideKeyboardHandler<E>?

    /// Rx support
    internal var _disposeBag = DisposeBag()

    // MARK: - FxForm Lifecycle

    /// Initializes an FxForm.
    /// ```
    /// let fields = viewModel.setup(contact: contact)
    /// form = FxForm(fields, viewController: self, scrollView: scrollView)
    /// ```
    /// - Parameters:
    ///   - fields: List of fields to be bound.
    ///   - viewController: UIViewController that contains the form and the @IBOutlet's to be bound to the form.
    ///   - scrollView: UIScrollView to be managed, if any.
    public init(_ fields: FxFields<E>, viewController: UIViewController, scrollView: UIScrollView? = nil) {
        super.init()

        self.fields = fields

        self._viewController = viewController
        _viewControllerProperties = properties(for: viewController)

        if let scrollView = scrollView {
            self._viewScroller = FxScrollingService(scrollView: scrollView)
        }

        #if DEBUG
            FxResourceTracking.track(ObjectIdentifier(self).hashValue, "FxForm")
        #endif
    }

    deinit {
        #if DEBUG
            FxResourceTracking.release(ObjectIdentifier(self).hashValue)
        #endif
    }

    // MARK: - FxForm Functionality

    /// Convenience method to clear all of a form's bound fields. Will **not** clear unbound field values.
    public func clear() {
        tabOrder.forEach { f in f.clear() }
    }

    // MARK: - Subscripting

    /// Returns FxField<E> with the given id. Note that this field is returned from the managed fields list and may not neccesarily be
    /// bound to any particular view or control.
    public subscript(_ id: E) -> FxField<E>? {
        get {
            return fields[id]
        }
    }

    // MARK: - Sequencing

    /// Returns iterator that will sequence through all bound FxField<E>'s in tab order.
    public func makeIterator() -> FxFormIterator<E> {
        return FxFormIterator<E>(tabOrder)
    }

    // MARK: - FxForm Internal Functions

    internal func properties(for viewController: UIViewController) -> [String:Int] {
        var p: [String:Int] = [:]
        for c in Mirror(reflecting: viewController).children {
            if let name = c.label {
                p[name] = p.count
            }
        }
        return p
    }

    internal func findViewControllerElement<T>(_ key: String) -> T? {
        guard _viewControllerProperties[key] != nil else {
            return nil
        }
        guard let element = _viewController.value(forKey: key) as? T else {
            return nil
        }
        return element
    }

}

public struct FxFormIterator<E:Hashable>: IteratorProtocol {
    let fields: [FxField<E>]
    var index = 0

    init(_ fields: [FxField<E>]) {
        self.fields = fields
    }

    mutating public func next() -> FxField<E>? {
        guard index < fields.count else { return nil }
        let field = fields[index]
        index += 1
        return field
    }
}
