//
//  MetaTextDecoratorMessage.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/22/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

open class MetaTextDecoratorMessage: MetaTextBehaviorErrorHandling, MetaTextDecoratingSize, MetaTextBehaviorRemovable {

    public static let name = "MetaTextDecoratorMessage"

    public var name: String? { return MetaTextDecoratorMessage.name }
    public var priority: MetaTextPriority { return .mediumLow }

    public var errorMessage: String? = nil {
        didSet { messageUpdated() }
    }

    public var helpMessage: String? = nil {
        didSet { messageUpdated() }
    }

    public var font: UIFont = UIFont.preferredFont(forTextStyle: .footnote) {
        didSet { label?.font = font }
    }

    public var offset: CGFloat = 0.0 {
        didSet { updateLabelPosition() }
    }

    public var padding: CGFloat = 4.0 {
        didSet { updateLabelPosition() }
    }

    public var errorColor: UIColor = .red  {
        didSet { label?.textColor = errorColor }
    }

    public var helpColor: UIColor = .gray  {
        didSet { label?.textColor = helpColor }
    }

    public var automaticallyHandleErrorMessage: Bool = true
    public var defaultAnimationDuration: TimeInterval = 0.5

    internal weak var textField: MetaTextField?
    internal var baseSize = CGSize.zero

    internal var isAnimating = false
    internal var label: UILabel? = nil
    internal var labelTopConstraint: NSLayoutConstraint? = nil
    internal var labelLeftConstraint: NSLayoutConstraint? = nil

    init() {

    }

    // MetaTextDecorator

    public func add(to textField: MetaTextField) -> Bool {
        self.textField = textField
        setupLabel()
        return true
    }

    public func removed(from textField: MetaTextField) {
        label?.removeFromSuperview()
    }

    // MetaTextBehaviorErrorHandling

    public func handleErrorMessage(_ message: String?) {
        if automaticallyHandleErrorMessage {
            errorMessage = message
        }
    }

    // MetaTextDecoratorContentSize

    public func intrinsicContentSize(_ current: CGSize) -> CGSize? {
        var intrinsicSize = current
        if hasMessage {
            intrinsicSize.height += padding + label!.frame.height + padding
        }
        return intrinsicSize
    }

    // Message

    func messageUpdated() {
        OperationQueue.main.addOperation {
            self.layoutLabel(animated: true)
        }
    }

    func getColor() -> UIColor {
        return hasErrorMessage ? errorColor : helpColor
    }

    func getMessage() -> String? {
        if let message = errorMessage, !message.isEmpty {
            return message
        }
        if let message = helpMessage, !message.isEmpty {
            return message
        }
        return nil
    }

    var hasMessage: Bool {
        return getMessage() != nil
    }

    var hasHelpMessage: Bool {
        return !(helpMessage?.isEmpty ?? true)
    }

    var hasErrorMessage: Bool {
        return !(errorMessage?.isEmpty ?? true)
    }

    func setupLabel() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = getColor()
        label.alpha = 0
        self.label = label
        updateLabelProperties()
        textField?.addSubview(label)
        setupErrorConstraints()
        layoutLabel(animated: false)
    }

    func setupErrorConstraints() {
        if let label = label {
            let views = ["error":label]
            let metrics = ["topPadding": labelPositionY()]
            let vConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-topPadding-[error]-(>=0,0@900)-|",
                options: [],
                metrics: metrics,
                views: views)
            labelTopConstraint = vConstraints[0]
            textField?.addConstraints(vConstraints)
            let hConstraints = NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[error]->=0-|",
                options: [],
                metrics: metrics,
                views: views)
            labelLeftConstraint = hConstraints[0]
            textField?.addConstraints(hConstraints)
        }
    }

    func layoutLabel(animated: Bool) {
        if hasMessage {
            showLabel(animated: animated)
        } else {
            hideLabel(animated: animated)
        }
    }

    func showLabel(animated: Bool) {
        updateLabelText()
        if animated && !isAnimating {
            isAnimating = true
            textField?.superview?.layoutIfNeeded()
            UIView .animate(withDuration: self.defaultAnimationDuration, delay: 0.0, options: .curveEaseInOut, animations: {
                self.labelTopConstraint?.constant = self.labelPositionY()
                self.label?.alpha = 1.0
                self.label?.textColor = self.getColor()
                self.textField?.superview?.layoutIfNeeded()
            }, completion: { finished in
                self.isAnimating = false
                if !self.hasMessage {
                    self.hideLabel(animated: false)
                }
            })
        } else if (!animated) {
            label?.alpha = 1.0
            label?.isHidden = false
            labelTopConstraint?.constant = labelPositionY()
        }
    }

    func hideLabel(animated: Bool) {
        if animated && !isAnimating {
            isAnimating = true
            UIView .animate(withDuration: self.defaultAnimationDuration * 0.4, delay: 0.0, options: .curveEaseOut, animations: {
                self.label?.alpha = 0.0
            }, completion: { finished in
                self.textField?.superview?.layoutIfNeeded()
                self.labelTopConstraint?.constant = self.labelPositionY()
                UIView .animate(withDuration: self.defaultAnimationDuration * 0.4, delay: 0.0, options: .curveEaseOut, animations: {
                    self.textField?.superview?.layoutIfNeeded()
                }, completion: { finished in
                    self.isAnimating = false
                    self.updateLabelText()
                    if self.hasMessage {
                        self.hideLabel(animated: false)
                    }
                })
                if !self.hasMessage {
                    self.hideLabel(animated: false)
                }
            })
        } else if (!animated) {
            label?.alpha = 0.0
            labelTopConstraint?.constant = labelPositionY()
            updateLabelText()
        }
    }

    func labelPositionY() -> CGFloat {
        guard let textField = textField, let font = textField.font else {
            return 0
        }
        return textField.layoutMargins.top + font.lineHeight + textField.layoutMargins.bottom + padding
    }

    func updateLabelPosition() {
        labelTopConstraint?.constant = labelPositionY()
        labelLeftConstraint?.constant = offset
    }

    func updateLabelProperties() {
        label?.font = font
        label?.textColor = errorColor
    }

    func updateLabelText() {
        label?.text = getMessage()
        label?.sizeToFit()
    }

    func removeLabel() {
        label?.removeFromSuperview()
        label = nil
    }

}
