//
//  MetaTextDecoratorTintClearImage.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/18/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//
import UIKit

public class MetaTextDecoratorTintPlaceholder: MetaTextDecoratingLayout {

    public static let name = "MetaTextDecoratorTintPlaceholder"

    public var name: String? { return MetaTextDecoratorTintPlaceholder.name }
    public var priority: MetaTextPriority { return .low }

    internal weak var textField: MetaTextField?

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
        let color = textField.tintColor.withAlphaComponent(0.5)
        let attributes = [NSAttributedStringKey.foregroundColor: color]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }

}
