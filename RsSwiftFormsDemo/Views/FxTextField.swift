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

    // MARK: - Help Properties

    public var helpMessage: String? = nil {
        didSet { messageBehavior.helpMessage = helpMessage }
    }

    // MARK: - Error Properties

    public var showErrorMessages: Bool = true {
        didSet {
            if showErrorMessages {
                add(behavior: messageBehavior)
            } else {
                removeBehavior(name: messageBehavior.name)
            }
        }
    }

    public var errorMessage: String? = nil {
        didSet { messageBehavior.errorMessage = errorMessage }
    }

    public var errorFont: UIFont = UIFont.preferredFont(forTextStyle: .footnote) {
        didSet { messageBehavior.font = errorFont }
    }

    public var errorColor: UIColor = .red  {
        didSet { messageBehavior.errorColor = errorColor }
    }

    public var errorOffset: CGFloat = 0.0 {
        didSet { messageBehavior.offset = errorOffset }
    }

    public var errorPadding: CGFloat = 3.0 {
        didSet { messageBehavior.padding = errorPadding }
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
        add(behavior: messageBehavior)
    }

    internal let messageBehavior = MetaTextDecoratorMessage()

}
