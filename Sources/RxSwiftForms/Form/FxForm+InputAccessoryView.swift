//
//  FxForm+InputAccessoryView.swift
//  FxProject
//
//  Created by Michael Long on 2/12/17.
//  Copyright © 2017 com.hmlong. All rights reserved.
//

import UIKit

extension FxForm: FxInputAccessoryViewDelegate {

    /// Adds the specfied input accessory view to all bound text fields and text views.
    /// ```
    /// form.autoBind()
    ///     .addInputAccessoryView()
    /// ```
    /// Automatically sets delegate if accessory view conforms to `FxInputAccessoryViewInterface`.
    ///
    /// Note: Bind all fields **before** calling this method.
    /// - Parameter view: The input accessory view.
    /// - Returns: Self for further customization.
    @discardableResult
    public func addInputAccessoryView(_ view: UIView? = nil) -> FxForm<E> {
        guard !tabOrder.isEmpty else {
            fatalError("addInputAccessoryView can only be called after fields are bound")
        }
        let inputAccessoryView = view ?? FxInputAccessoryViewHideNext()
        if var interface = inputAccessoryView as? FxInputAccessoryViewInterface {
            interface.accessoryDelegate = self
        }
        for field in tabOrder {
            if let textfield = field.view as? UITextField {
                textfield.inputAccessoryView = inputAccessoryView
            } else if let textview = field.view as? UITextView {
                textview.inputAccessoryView = inputAccessoryView
            }
        }
        return self
    }

}
