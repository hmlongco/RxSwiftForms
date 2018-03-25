//
//  FxField+Error.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/9/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public protocol FxErrorHandling {
    func handleErrorMessage(_ message: String?)
}

extension FxField {

    // MARK: - Error

    /// Gets the current error message. Value will be propagated to bound view, if any.
    public var error: String? {
        get { return _error.value }
        set { _error.accept(newValue) }
    }

    public func clearError() {
        _error.accept(nil)
    }

}

public extension FxFieldReactiveBase{

    /// Error message value that's determined during field validation.
    public var errorMessage: Observable<String?> {
        return base._error.asObservable()
    }

    /// Validation state that's determined during field validation.
    public var isValid: Observable<Bool> {
        return base._error.map { $0 == nil }
    }

}

extension Reactive where Base: UIView {

    public var fxErrorMessage: Binder<String?> {
        return Binder<String?>(base, binding: { (base, message) in
            if let bindable = base as? FxErrorHandling {
                bindable.handleErrorMessage(message)
            }
        })
    }

}
