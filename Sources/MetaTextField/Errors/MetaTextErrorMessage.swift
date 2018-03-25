//
//  MetaTextErrorMessage.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/22/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

public class MetaTextErrorMessage: MetaTextBehaviorErrorHandling, MetaTextDecoratingSize, MetaTextBehaviorRemovable {

    public static let name = "MetaTextErrorMessage"

    public var name: String? { return MetaTextErrorMessage.name }
    public var priority: MetaTextPriority { return .mediumLow }

    public var errorMessage: String? = nil {
        didSet { errorMessageUpdated() }
    }

    public var errorFont: UIFont = UIFont.preferredFont(forTextStyle: .footnote) {
        didSet { errorLabel?.font = errorFont }
    }

    public var errorColor: UIColor = .red  {
        didSet { errorLabel?.textColor = errorColor }
    }

    public var errorPadding: CGFloat = 4.0 {
        didSet { updateErrorLabelPosition() }
    }

    public var defaultAnimationDuration: TimeInterval = 0.5

    internal weak var textField: MetaTextField?
    internal var baseSize = CGSize.zero

    internal var errorIsAnimating = false
    internal var errorLabel: UILabel? = nil
    internal var errorLabelTopConstraint: NSLayoutConstraint? = nil

    init() {

    }

    // MetaTextDecorator

    public func add(to textField: MetaTextField) -> Bool {
        self.textField = textField
        setupErrorLabel()
        return true
    }

    public func removed(from textField: MetaTextField) {
        errorLabel?.removeFromSuperview()
    }

    // MetaTextBehaviorErrorHandling

    public func handleErrorMessage(_ message: String?) {
        errorMessage = message
    }

    // MetaTextDecoratorContentSize

    public func intrinsicContentSize(_ current: CGSize) -> CGSize? {
        var intrinsicSize = current
        if hasError {
            intrinsicSize.height += errorPadding + errorLabel!.frame.height + errorPadding
        }
        return intrinsicSize
    }

    // Errors

    func errorMessageUpdated() {
        OperationQueue.main.addOperation {
            self.layoutErrorLabel(animated: true)
        }
    }

    var hasError: Bool {
        return !(errorMessage?.isEmpty ?? true)
    }

    func setupErrorLabel() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = errorColor
        label.alpha = 0
        self.errorLabel = label
        updateErrorLabelProperties()
        textField?.addSubview(label)
        setupErrorConstraints()
        layoutErrorLabel(animated: false)
    }

    func setupErrorConstraints() {
        if let errorLabel = errorLabel {
            let views = ["error":errorLabel]
            let metrics = ["topPadding": errorLabelPositionY()]
            let vConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-topPadding-[error]-(>=0,0@900)-|",
                options: [],
                metrics: metrics,
                views: views)
            errorLabelTopConstraint = vConstraints[0]
            textField?.addConstraints(vConstraints)
            let hConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[error]->=0-|",
                options: [],
                metrics: metrics,
                views: views)
            textField?.addConstraints(hConstraints)
        }
    }

    func layoutErrorLabel(animated: Bool) {
        if hasError {
            showErrorLabel(animated: animated)
        } else {
            hideErrorLabel(animated: animated)
        }
    }

    func showErrorLabel(animated: Bool) {
        updateErrorLabelText()
        if animated && !errorIsAnimating {
            errorIsAnimating = true
            textField?.superview?.layoutIfNeeded()
            UIView .animate(withDuration: self.defaultAnimationDuration, delay: 0.0, options: .curveEaseInOut, animations: {
                self.errorLabelTopConstraint?.constant = self.errorLabelPositionY()
                self.errorLabel?.alpha = 1.0
                self.textField?.superview?.layoutIfNeeded()
            }, completion: { finished in
                self.errorIsAnimating = false
                if !self.hasError {
                    self.hideErrorLabel(animated: false)
                }
            })
        } else if (!animated) {
            errorLabel?.alpha = 1.0
            errorLabel?.isHidden = false
            errorLabelTopConstraint?.constant = errorLabelPositionY()
        }
    }

    func hideErrorLabel(animated: Bool) {
        if animated && !errorIsAnimating {
            errorIsAnimating = true
            UIView .animate(withDuration: self.defaultAnimationDuration * 0.4, delay: 0.0, options: .curveEaseOut, animations: {
                self.errorLabel?.alpha = 0.0
            }, completion: { finished in
                self.textField?.superview?.layoutIfNeeded()
                self.errorLabelTopConstraint?.constant = self.errorLabelPositionY()
                UIView .animate(withDuration: self.defaultAnimationDuration * 0.4, delay: 0.0, options: .curveEaseOut, animations: {
                    self.textField?.superview?.layoutIfNeeded()
                }, completion: { finished in
                    self.errorIsAnimating = false
                    self.updateErrorLabelText()
                    if self.hasError {
                        self.hideErrorLabel(animated: false)
                    }
                })
                if !self.hasError {
                    self.hideErrorLabel(animated: false)
                }
            })
        } else if (!animated) {
            errorLabel?.alpha = 0.0
            errorLabelTopConstraint?.constant = errorLabelPositionY()
            updateErrorLabelText()
        }
    }

    func errorLabelPositionY() -> CGFloat {
        guard let textField = textField, let font = textField.font else {
            return 0
        }
        return textField.layoutMargins.top + font.lineHeight + textField.layoutMargins.bottom + errorPadding
    }

    func updateErrorLabelPosition() {
        errorLabelTopConstraint?.constant = errorLabelPositionY()
    }

    func updateErrorLabelProperties() {
        errorLabel?.font = errorFont
        errorLabel?.textColor = errorColor
    }

    func updateErrorLabelText() {
        errorLabel?.text = (errorMessage?.isEmpty ?? true) ? nil : errorMessage
        errorLabel?.sizeToFit()
    }

    func removeErrorLabel() {
        errorLabel?.removeFromSuperview()
        errorLabel = nil
    }

}
