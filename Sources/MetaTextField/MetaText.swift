//
//  MetaText.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/17/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

public enum MetaTextPriority: Int {
    case highest = 1
    case higher
    case high
    case mediumHigh
    case medium
    case mediumLow
    case low
    case lower
    case lowest
}

public enum MetaTextRectType {
    case clear
    case editing
    case left
    case placeholder
    case right
    case selection
    case text
}

public enum MetaTextResponderStatus {
    case becameFirst
    case resignedFirst
}

public protocol MetaTextBehavior: class {
    var name: String? { get }
    var priority: MetaTextPriority { get }
    func add(to textField: MetaTextField) -> Bool
}

public protocol MetaTextBehaviorActionable: MetaTextBehavior {
    func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool?
}

public protocol MetaTextBehaviorChanging: MetaTextBehavior {
    func shouldChangeText(_ textField: UITextField, _ range: NSRange, _ string: String) -> Bool?
}

public protocol MetaTextBehaviorErrorHandling: MetaTextBehavior {
    func handleErrorMessage(_ message: String?)
}

public protocol MetaTextBehaviorRemovable: class {
    func removed(from textField: MetaTextField)
}

public protocol MetaTextBehaviorResponding: MetaTextBehavior {
    var canBecomeFirstResponder: Bool? { get }
    func responder(status: MetaTextResponderStatus)
}

public protocol MetaTextDecorating: MetaTextBehavior {
    // empty for now
}

public protocol MetaTextDecoratingDraw: MetaTextDecorating {
    func draw(_ rect: CGRect)
}

public protocol MetaTextDecoratingLayout: MetaTextDecorating {
    func layoutSubviews()
}

public protocol MetaTextDecoratingSize: MetaTextDecorating {
    func intrinsicContentSize(_ current: CGSize) -> CGSize?
}

public protocol MetaTextDecoratingRects: MetaTextDecorating {
    func caretRect(for position: UITextPosition, current: CGRect) -> CGRect?
    func rect(_ type: MetaTextRectType, bounds: CGRect, current: CGRect) -> CGRect?
    func selectionRects(for range: UITextRange, current: [Any]?) -> [Any]?
}
