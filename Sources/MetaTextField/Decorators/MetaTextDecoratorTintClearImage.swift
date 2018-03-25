//
//  MetaTextDecoratorTintClearImage.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/18/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//
import UIKit

public class MetaTextDecoratorTintClearImage: MetaTextDecoratingLayout {

    public static let name = "MetaTextDecoratorTintClearImage"

    public var name: String? { return MetaTextDecoratorTintClearImage.name }
    public var priority: MetaTextPriority { return .low }

    internal weak var textField: MetaTextField?

    public func add(to textField: MetaTextField) -> Bool {
        self.textField = textField
        return true
    }

    // MARK: - Decorating

    public func layoutSubviews() {
        tintClearImage()
    }

    private var tintedClearImage: UIImage?

    private func tintClearImage() {
        guard let textField = textField else {
            return
        }
        for view in textField.subviews {
            if let button = view as? UIButton, let image = button.image(for: .highlighted) {
                if tintedClearImage == nil {
                    tintedClearImage = tintImage(image: image, color: textField.tintColor)
                }
                button.setImage(tintedClearImage, for: .normal)
                button.setImage(tintedClearImage, for: .highlighted)
            }
        }
    }

    private func tintImage(image: UIImage, color: UIColor) -> UIImage {
        let size = image.size

        UIGraphicsBeginImageContextWithOptions(size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        image.draw(at: CGPoint.zero, blendMode: CGBlendMode.normal, alpha: 1.0)
        context?.setFillColor(color.cgColor)
        context?.setBlendMode(CGBlendMode.sourceIn)
        context?.setAlpha(1.0)
        let rect = CGRect(x:CGPoint.zero.x, y:CGPoint.zero.y, width:image.size.width, height:image.size.height)
        context?.fill(rect)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return tintedImage!
    }

}

