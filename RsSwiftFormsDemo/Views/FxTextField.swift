//
//  FxTextField.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/4/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import UIKit


public class FxTextField: MetaTextField, FxErrorHandling {

    // MARK: - Properties

    public var disclosureImage: UIImage? {
        didSet {
            add(behavior: MetaTextDecoratorDisclosure(disclosureImage))
        }
    }

    public var maskFormat: String? {
        didSet {
            add(behavior: MetaTextBehaviorMaskedNumeric(maskFormat))
        }
    }

    public var maxLength: Int = 0 {
        didSet {
            add(behavior: MetaTextBehaviorMaxLength(maxLength))
        }
    }

    // MARK: - Error Properties

    public var showErrorMessages: Bool = true {
        didSet {
            if showErrorMessages {
                add(behavior: errorMessageBehavior)
            } else {
                removeBehavior(name: errorMessageBehavior.name)
            }
        }
    }

    public var errorMessage: String? = nil {
        didSet { errorMessageBehavior.errorMessage = errorMessage }
    }

    public var errorFont: UIFont = UIFont.preferredFont(forTextStyle: .footnote) {
        didSet { errorMessageBehavior.errorFont = errorFont }
    }

    public var errorColor: UIColor = .red  {
        didSet { errorMessageBehavior.errorColor = errorColor }
    }

    public var errorPadding: CGFloat = 3.0 {
        didSet { errorMessageBehavior.errorPadding = errorPadding }
    }

    // MARK: - Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initFxTextField()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFxTextField()
    }

    public func initFxTextField() {
        add(behavior: errorMessageBehavior)
    }

    internal let errorMessageBehavior = MetaTextErrorMessage()

}
