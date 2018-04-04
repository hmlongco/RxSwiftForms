//
//  MetaTextDecoratorBorder.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/22/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

open class MetaTextDecoratorBorder: MetaTextDecoratingLayout, MetaTextDecoratingSize, MetaTextDecoratingRects,
    MetaTextBehaviorErrorHandling, MetaTextBehaviorRemovable {

    public static let name = "MetaTextDecoratorBorderStyle"

    public var color: UIColor? {
        didSet {
            textField?.setNeedsDisplay()
        }
    }

    public var editingColor: UIColor?  {
        didSet {
            textField?.setNeedsDisplay()
        }
    }

    public var errorColor: UIColor?  {
        didSet {
            textField?.setNeedsDisplay()
        }
    }

    public var radius: CGFloat = 4 {
        didSet {
            textField?.setNeedsLayout()
        }
    }

    public var width: CGFloat = 1 {
        didSet {
            textField?.setNeedsLayout()
        }
    }

    public var name: String? { return MetaTextDecoratorBorder.name }
    public var priority: MetaTextPriority { return .mediumHigh }

    weak var textField: MetaTextField?

    private var textLineHeight: CGFloat?
    private var startingBackgroundColor: UIColor?
    private var errorState = false
    private let layer = CALayer()

    // MARK: - Lifecycle

    public init(
        color: UIColor? = nil,
        editingColor: UIColor? = nil,
        errorColor: UIColor? = nil,
        padding: CGFloat? = nil,
        width: CGFloat = 1) {
        self.color = color
        self.editingColor = editingColor
        self.errorColor = errorColor
        self.width = width
    }

    public func add(to textField: MetaTextField) -> Bool {
        self.textField = textField
        setTextFieldProperties()
        return true
    }

    public func removed(from textField: MetaTextField) {
        layer.removeFromSuperlayer()
    }

    func setTextFieldProperties() {
        textField?.borderStyle = .none
        textField?.contentVerticalAlignment = .top
        textField?.clipsToBounds = false
        textField?.layer.addSublayer(layer)

        startingBackgroundColor = textField?.backgroundColor
        textField?.backgroundColor = .clear
    }

    // MARK: - MetaTextDecorator

    public func layoutSubviews() {
        textLineHeight = nil
        layoutBorder()
    }

    public func layoutBorder() {
        guard let textField = textField else { return }

        layer.frame = CGRect(x: 0, y: 0, width: textField.bounds.width, height: calculatedHeight - calculatedBottomMargin)
        layer.backgroundColor = startingBackgroundColor?.cgColor
        layer.borderColor = currentColor.cgColor
        layer.borderWidth = width
        layer.cornerRadius = radius
     }

    public func intrinsicContentSize(_ current: CGSize) -> CGSize? {
        return CGSize(width: current.width, height: calculatedHeight)
    }

    public func caretRect(for position: UITextPosition, current: CGRect) -> CGRect? {
        return nil
    }

    public func rect(_ type: MetaTextRectType, bounds: CGRect, current: CGRect) -> CGRect? {
        guard let textField = textField else {
            return nil
        }
        var rect = current
        switch type {
        case .clear:
            rect.origin.y = calculatedTopMargin + max((calculatedTextHeight - current.height) / 2.0, 0.0)
        case .left:
            rect.origin.x = textField.layoutMargins.left
            rect.origin.y = calculatedTopMargin + max((calculatedTextHeight - current.height) / 2.0, 0.0)
        case .right:
            rect.origin.x = bounds.width - current.width - textField.layoutMargins.right
            rect.origin.y = calculatedTopMargin + max((calculatedTextHeight - current.height) / 2.0, 0.0)
        default:
            // adjust height
            rect.origin.x = textField.layoutMargins.left
            rect.origin.y = calculatedTopMargin
            rect.size.height = calculatedTextHeight
            rect.size.width = bounds.width - (textField.layoutMargins.left + textField.layoutMargins.right)
            // adjust width
            let lr = textField.leftViewRect(forBounds: bounds)
            if lr.width > 0 {
                rect.origin.x += lr.width + 4
                rect.size.width -= (lr.width + 4)
            }
            let rr = textField.rightViewRect(forBounds: bounds)
            if rr.width > 0 {
                rect.size.width -= (rr.width + 4)
            }
            let cr = textField.clearButtonRect(forBounds: bounds)
            if cr.width > 0 {
                rect.size.width -= (cr.width + 4)
            }
        }
        return rect
    }

    public func selectionRects(for range: UITextRange, current: [Any]?) -> [Any]? {
        return nil
    }

    var calculatedHeight: CGFloat {
        return calculatedLineWidth + calculatedTopMargin + calculatedTextHeight + calculatedLinePadding + calculatedLineWidth + calculatedBottomMargin
    }

    var calculatedTopMargin: CGFloat {
        guard let textField = textField else { return 4 }
        return textField.layoutMargins.top
    }

    var calculatedTextHeight: CGFloat {
        if let textLineHeight = textLineHeight {
            return textLineHeight
        }
        guard let textField = textField else { return 8 }
        textLineHeight = textField.font?.lineHeight ?? UIFont.systemFont(ofSize: UIFont.systemFontSize).lineHeight
        return textLineHeight!
    }

    var calculatedLinePadding: CGFloat {
        return (textField?.layoutMargins.bottom ?? 8) / 2
    }

    var calculatedLineY: CGFloat {
        return width + calculatedTopMargin + calculatedTextHeight + calculatedLinePadding
    }

    var calculatedLineWidth: CGFloat {
        return width
    }

    var calculatedBottomMargin: CGFloat {
        return calculatedLinePadding
    }

    var currentColor: UIColor {
        guard let textField = textField else {
            return .clear
        }
        if let color = errorColor, errorState {
            return color
        }
        if let color = editingColor, textField.isFirstResponder {
            return color
        }
        if let color = color {
            return color
        }
        return textField.tintColor
    }

    // MARK: - MetaTextBehaviorErrorHandling

    public func handleErrorMessage(_ message: String?) {
        errorState = !(message?.isEmpty ?? true)
        textField?.setNeedsLayout()
    }

}

