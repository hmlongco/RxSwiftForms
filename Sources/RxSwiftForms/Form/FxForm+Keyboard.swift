//
//  FxForm+Keyboard.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/13/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

public extension FxForm {

    /// Adds a hide keyboard tap gesture handler to the specified view.
    /// ```
    /// form.autoBind()
    ///     .addHideKeyboardGesture()
    /// ```
    /// If no view is specified the gesture is added to the scrollview or if that doesn't exist, to the view controller's view.
    @discardableResult
    public func addHideKeyboardGesture(_ view: UIView? = nil) -> FxForm<E> {
        if _hideKeyboardGesture == nil {
            let view = view ?? _viewScroller?.scrollView ?? _viewController.view
            _hideKeyboardGesture = FxHideKeyboardHandler(self, view: view)
        }
        return self
    }

}

internal class FxHideKeyboardHandler<E:Hashable>: NSObject {

    weak var form: FxForm<E>?

    init(_ form: FxForm<E>, view: UIView?) {
        self.form = form
        super.init()
        addHideKeyboardGesture(view)
    }

    func addHideKeyboardGesture(_ view: UIView?) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FxHideKeyboardHandler.doneEditing))
        tap.cancelsTouchesInView = false
        view?.addGestureRecognizer(tap)
    }

    @objc
    public func doneEditing() {
        form?.doneEditing()
    }
}
