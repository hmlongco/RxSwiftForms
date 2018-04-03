//
//  FxViewAtrributes.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/17/17.
//  Copyright © 2018 com.hmlong. All rights reserved.
//

import UIKit

open class FxViewAttributes: FxAttributes<UIView> {}

/// Extends UIView with associated elements, simplifing field management and lookups for tabbing and other events.
public extension UIView {
    var fx: FxViewAttributes {
            if let attributes = objc_getAssociatedObject(self, &FxViewAttributesHandle) as? FxViewAttributes {
                return attributes
            }
            let attributes = FxViewAttributes(self)
            objc_setAssociatedObject(self, &FxViewAttributesHandle, attributes, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return attributes
    }
}

internal var FxViewAttributesHandle:UInt8 = 0
