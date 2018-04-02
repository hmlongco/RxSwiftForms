//
//  FxMaterialTextField.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/5/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

public class FxMaterialTextField: FxTextField {

    // MARK: - Properties

    public var underlineColor: UIColor? = nil {
        didSet { underlineDecorator.color = underlineColor }
    }
    public var underlineEditingHeight: CGFloat = 2.0 {
        didSet { underlineDecorator.editingWidth = underlineEditingHeight }
    }
    public var underlineWidth: CGFloat = 1.0 {
        didSet { underlineDecorator.width = underlineWidth }
    }

    internal let underlineDecorator = MetaTextDecoratorUnderline()

    // MARK: - Lifecycle

    override public func initFxTextField() {
        super.initFxTextField()
        add(behavior: underlineDecorator)
        add(behavior: MetaTextDecoratorTintClearImage())
        add(behavior: MetaTextDecoratorTintPlaceholder())
    }

}
