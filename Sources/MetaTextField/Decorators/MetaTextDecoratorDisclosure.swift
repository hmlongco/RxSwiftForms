//
//  MetaTextDecoratorDisclosure.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/17/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

public class MetaTextDecoratorDisclosure: MetaTextDecoratingRects, MetaTextBehaviorActionable, MetaTextBehaviorChanging, MetaTextBehaviorResponding {

    public static let name = "MetaTextDecoratorDisclosure"

    public var name: String? { return MetaTextDecoratorDisclosure.name }
    public var priority: MetaTextPriority { return .high }

    internal weak var textField: MetaTextField?
    internal var image: UIImage?
    internal let handler: ((_ textField: MetaTextField) -> Void)?

    init(_ image: UIImage?, handler: ((_ textField: MetaTextField) -> Void)? = nil) {
        self.image = image
        self.handler = handler
    }

    public func add(to textField: MetaTextField) -> Bool {
        self.textField = textField

        if let image = image {
            let imageView = UIImageView(image: image)
            imageView.tintColor = textField.tintColor
            textField.rightView = imageView
            textField.rightViewMode = .always
            textField.clearButtonMode = .never
        }

        return true
    }

    // MARK: - Decorating

    public func caretRect(for position: UITextPosition, current: CGRect) -> CGRect? {
        return .zero
    }

    public func rect(_ type: MetaTextRectType, bounds: CGRect, current: CGRect) -> CGRect? {
        return nil
    }

    public func selectionRects(for range: UITextRange, current: [Any]?) -> [Any]? {
        return []
    }

    // MARK: - Behaviors

    public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool? {
        return false
    }

    public func shouldChangeText(_ textField: UITextField, _ range: NSRange, _ string: String) -> Bool? {
        return false
    }

    // MARK: - Responding

    public var canBecomeFirstResponder: Bool? { return nil }

    public func responder(status: MetaTextResponderStatus) {
        guard let textField = textField else { return }
        if status == .becameFirst {
            handler?(textField)
        }
    }

}
