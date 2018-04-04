//
//  MetaTextDecoratorUnderline.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/20/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

open class MetaTextDecoratorUnderline: MetaTextDecoratingLayout, MetaTextDecoratingSize, MetaTextDecoratingRects,
    MetaTextBehaviorErrorHandling, MetaTextBehaviorRemovable {

    public static let name = "MetaTextDecoratorBorderStyle"

    public var color: UIColor? {
        didSet {
            textField?.setNeedsDisplay()
        }
    }

    public var errorColor: UIColor?  {
        didSet {
            textField?.setNeedsDisplay()
        }
    }

    public var width: CGFloat = 1 {
        didSet {
            textField?.setNeedsLayout()
        }
    }

    public var editingWidth: CGFloat = 2 {
        didSet {
            textField?.setNeedsLayout()
        }
    }

    public var name: String? { return MetaTextDecoratorUnderline.name }
    public var priority: MetaTextPriority { return .mediumHigh }

    weak var textField: MetaTextField?

    private var textLineHeight: CGFloat?
    private var errorState = false
    private let layer = CALayer()

    // MARK: - Lifecycle

    public init(
        color: UIColor? = nil,
        errorColor: UIColor? = nil,
        padding: CGFloat? = nil,
        width: CGFloat = 1,
        editingWidth: CGFloat = 2) {
        self.color = color
        self.errorColor = errorColor
        self.width = width
        self.editingWidth = editingWidth
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
    }

    // MARK: - MetaTextDecorator

    public func draw(_ rect: CGRect) {
        // Empty
    }

    public func layoutSubviews() {
        textLineHeight = nil
        layoutUnderline()
    }

    public func layoutUnderline() {
        guard let textField = textField else { return }

        layer.frame = CGRect(x: 0, y: calculatedLineY, width: textField.bounds.width, height: calculatedLineWidth)
        layer.backgroundColor = currentColor.cgColor
    }

    public func intrinsicContentSize(_ current: CGSize) -> CGSize? {
        return CGSize(width: current.width, height: calculatedHeight)
    }

    public func caretRect(for position: UITextPosition, current: CGRect) -> CGRect? {
        return nil
    }

    public func rect(_ type: MetaTextRectType, bounds: CGRect, current: CGRect) -> CGRect? {
        var rect = current
        switch type {
        case .clear, .left, .right:
            rect.origin.y = calculatedTopMargin + max((calculatedTextHeight - current.height) / 2.0, 0.0)
        default:
            rect.origin.y = calculatedTopMargin
        }
        return rect
    }

    public func selectionRects(for range: UITextRange, current: [Any]?) -> [Any]? {
        return nil
    }

    var calculatedHeight: CGFloat {
        return calculatedTopMargin + calculatedTextHeight + calculatedLinePadding + max(width, editingWidth) + calculatedBottomMargin
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
        return calculatedTopMargin + calculatedTextHeight + calculatedLinePadding
    }

    var calculatedLineWidth: CGFloat {
        return textField?.isFirstResponder ?? false ? editingWidth : width
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
