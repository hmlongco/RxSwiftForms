//
//  MetaTextDecoratorShowPassword
//  RxSwiftForms
//
//  Created by Michael Long on 3/17/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

open class MetaTextDecoratorShowPassword: NSObject, MetaTextDecorating {

    public static let name = "MetaTextDecoratorShowPassword"

    public var name: String? { return MetaTextDecoratorShowPassword.name }
    public var priority: MetaTextPriority { return .medium }

    internal weak var textField: MetaTextField?
    internal var showImage: UIImage?
    internal var hideImage: UIImage?

    public init(showImage: UIImage?, hideImage: UIImage?) {
        self.showImage = showImage
        self.hideImage = hideImage
    }

    public func add(to textField: MetaTextField) -> Bool {
        self.textField = textField

        let imageView = UIImageView(image: textField.isSecureTextEntry ? showImage : hideImage)
        imageView.isUserInteractionEnabled = true
        imageView.accessibilityLabel = textField.isSecureTextEntry ? "Show Password" : "Hide Password"

        textField.rightView = imageView
        textField.rightViewMode = .whileEditing

        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        imageView.addGestureRecognizer(gesture)

        return true
    }

    // MARK: - Decorating

    @objc
    public func tapped() {
        if let textField = textField, let imageView = textField.rightView as? UIImageView {

            textField.isSecureTextEntry = !textField.isSecureTextEntry
            imageView.image = textField.isSecureTextEntry ? showImage : hideImage

            // force textfield to update its cursor rect
            let temp = textField.text
            textField.text = nil
            textField.text = temp
        }
    }

}
