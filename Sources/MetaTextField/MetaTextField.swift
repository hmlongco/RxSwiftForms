//
//  MetaTextField.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/17/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

public class MetaTextField: UITextField, UITextFieldDelegate {

    // MARK: - Properties

    public lazy var attributes = FxAttributes(self)
    public lazy var behaviors = [MetaTextBehavior]()

    // MARK: Lifecycle

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedSetup()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }

    func sharedSetup() {
        // hook for later overrides
    }

    // MARK: - Behaviors

    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        for item in behaviors {
            if let behavior = item as? MetaTextBehaviorActionable, let result = behavior.canPerformAction(action, withSender: sender) {
                return result
            }
        }
        return super.canPerformAction(action, withSender: sender)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        for item in behaviors {
            if let behavior = item as? MetaTextBehaviorChanging, let result = behavior.shouldChangeText(self, range, string) {
                return result
            }
        }
        return true
    }

    // MARK: - Behavior Setup

    @discardableResult
    public func add(behavior: MetaTextBehavior) -> MetaTextField {
        if behavior.add(to: self) {
            removeBehavior(name: behavior.name)
            behaviors.append(behavior)
            if behaviors.count > 1 {
                behaviors.sort(by: { (lhs, rhs) -> Bool in
                    lhs.priority.rawValue < rhs.priority.rawValue
                })
            }
            if behavior is MetaTextBehaviorChanging {
                delegate = self
            }
        }
        return self
    }

    public func removeBehavior(name: String?) {
        guard let name = name, !behaviors.isEmpty else { return }
        if let index = behaviors.index(where: { $0.name == name }) {
            (behaviors[index] as? MetaTextBehaviorRemovable)?.removed(from: self)
            behaviors.remove(at: index)
        }
    }

    public func behavior(for name: String) -> MetaTextBehavior? {
        if let index = behaviors.index(where: { $0.name == name }) {
            return behaviors[index]
        }
        return nil
    }

    // MARK: - Errors

    public func handleErrorMessage(_ message: String?) {
        behaviors.forEach { ($0 as? MetaTextBehaviorErrorHandling)?.handleErrorMessage(message) }
    }

    // MARK: - Decorators

    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        behaviors.forEach { ($0 as? MetaTextDecoratingDraw)?.draw(rect) }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        behaviors.forEach { ($0 as? MetaTextDecoratingLayout)?.layoutSubviews() }
    }

    // MARK: - Decorator Rects

    override public var intrinsicContentSize: CGSize {
        get {
            var intrinsicSize = super.intrinsicContentSize
            for item in behaviors {
                if let decorator = item as? MetaTextDecoratingSize, let updated = decorator.intrinsicContentSize(intrinsicSize) {
                    intrinsicSize = updated
                }
            }
            return intrinsicSize
        }
    }

   override public func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        for item in behaviors {
            if let decorator = item as? MetaTextDecoratingRects, let updated = decorator.caretRect(for: position, current: rect) {
                rect = updated
            }
        }
        return rect
    }

    override public func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        for item in behaviors {
            if let decorator = item as? MetaTextDecoratingRects, let updated = decorator.rect(.clear, bounds: bounds, current: rect) {
                rect = updated
            }
        }
        return rect
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.editingRect(forBounds: bounds)
        for item in behaviors {
            if let decorator = item as? MetaTextDecoratingRects, let updated = decorator.rect(.editing, bounds: bounds, current: rect) {
                rect = updated
            }
        }
        return rect
    }

    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        for item in behaviors {
            if let decorator = item as? MetaTextDecoratingRects, let updated = decorator.rect(.left, bounds: bounds, current: rect) {
                rect = updated
            }
        }
        return rect
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.placeholderRect(forBounds: bounds)
        for item in behaviors {
            if let decorator = item as? MetaTextDecoratingRects, let updated = decorator.rect(.placeholder, bounds: bounds, current: rect) {
                rect = updated
            }
        }
        return rect
    }

    override public func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        for item in behaviors {
            if let decorator = item as? MetaTextDecoratingRects, let updated = decorator.rect(.right, bounds: bounds, current: rect) {
                rect = updated
            }
        }
        return rect
    }

    override public func selectionRects(for range: UITextRange) -> [Any] {
        var rects = super.selectionRects(for: range)
        for item in behaviors {
            if let decorator = item as? MetaTextDecoratingRects, let updated = decorator.selectionRects(for: range, current: rects) {
                rects = updated
            }
        }
        return rects
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        for item in behaviors {
            if let decorator = item as? MetaTextDecoratingRects, let updated = decorator.rect(.text, bounds: bounds, current: rect) {
                rect = updated
            }
        }
        return rect
    }

    // MARK: - Responders

    override public func becomeFirstResponder() -> Bool {
        if super.becomeFirstResponder() {
            behaviors.forEach { ($0 as? MetaTextBehaviorResponding)?.responder(status: .becameFirst) }
            return true
        }
        return false
    }

    override public func resignFirstResponder() -> Bool {
        if super.resignFirstResponder() {
            behaviors.forEach { ($0 as? MetaTextBehaviorResponding)?.responder(status: .resignedFirst) }
            return true
        }
        return false
    }

}
