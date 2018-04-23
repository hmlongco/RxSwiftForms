//
//  MetaTextErrorPlaceholder.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/18/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//
import UIKit

open class MetaTextErrorPlaceholder: MetaTextDecoratingLayout, MetaTextBehaviorErrorHandling {

    public static let name = "MetaTextErrorPlaceholder"

    public var name: String? { return MetaTextErrorPlaceholder.name }
    public var priority: MetaTextPriority { return .high }

    internal weak var textField: MetaTextField?
    internal let normalColor: UIColor
    internal let errorColor: UIColor
    internal var currentColor: UIColor

    public init(color: UIColor, errorColor: UIColor) {
        self.currentColor = color
        self.normalColor = color
        self.errorColor = errorColor
    }

    public func add(to textField: MetaTextField) -> Bool {
        self.textField = textField
        return true
    }

    // MARK: - Decorating

    public func layoutSubviews() {
        tintPlaceholder()
    }

    private func tintPlaceholder() {
        guard let textField = textField else { return }
        let placeholder = textField.placeholder ?? ""
        let attributes = [NSAttributedStringKey.foregroundColor: currentColor.withAlphaComponent(0.3)]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }

    public func handleErrorMessage(_ message: String?) {
        currentColor = (message?.isEmpty ?? true) ? normalColor : errorColor
        textField?.setNeedsDisplay()
    }

}
