//
//  FxField+Title.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/20/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension FxField {

    // MARK: - Title

    /// Defines the field title. Titles may be bound to labels and are also used for error message generation.
    /// ```
    /// fields.add("zip").title("Zip Code")
    /// ```
    /// - Parameter title: String or nil to clear value.
    /// - Returns: Self for further configuration.
    @discardableResult
    public func title(_ title: String?) -> FxField {
        self.title = title
        return self
    }

    public var title: String? {
        get { return _title.value }
        set { _title.accept(newValue) }
    }

    internal var _title: BehaviorRelay<String?> {
        return relay(FxAttribute.TITLE, nil)
    }

}

public extension FxFieldReactiveBase  {

    /// Rx binding point for title property.
    public var title: ControlProperty<String?> {
        return ControlProperty(values: base._title, valueSink: Binder(base) { base, value in
            base._title.accept(value)
        })
    }

}
