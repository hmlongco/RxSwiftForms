//
//  FxBox.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/21/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation

/// Creates mutable reference wrapper for any type.
final class FxWeakBox<T:AnyObject> : CustomStringConvertible {
    /// Wrapped value
    weak var value : T?

    /// Creates reference wrapper for `value`.
    ///
    /// - parameter value: Value to wrap.
    init (_ value: T?) {
        self.value = value
    }
}

extension FxWeakBox {
    /// - returns: Box description.
    var description: String {
        return "FxWeakBox(\(String(describing: self.value)))"
    }
}
