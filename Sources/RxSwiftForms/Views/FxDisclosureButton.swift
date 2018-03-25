//
//  FxDisclosureButton.swift
//  FxProject
//
//  Created by Michael Long on 2/14/17.
//  Copyright © 2017 com.hmlong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

@IBDesignable

public class FxDisclosureButton: UIButton {

//    @IBInspectable public var placeholder: String?
//
//    var text: String? {
//        get {
//            if let t = titleLabel?.text {
//                return t == placeholder ? nil : t
//            }
//            return nil
//        }
//        set {
//            if let t = newValue {
//                setTitle(t, for: .normal)
//            } else {
//                setTitle(placeholder, for: .normal)
//            }
////            fxField?.changed()
//        }
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
//        if placeholder == nil {
//            placeholder = titleLabel?.text
//        }
    }

    override public func layoutSubviews() {
        // Allow default layout, then adjust image and label positions
        super.layoutSubviews()

        let imageView = self.imageView!
        let label = self.titleLabel!
        let padding:CGFloat = 5.0

        var imageFrame = imageView.frame
        var labelFrame = label.frame

        imageFrame.origin.x = bounds.size.width - imageFrame.size.width - padding

        labelFrame.origin.x = padding
        labelFrame.size.width = imageFrame.origin.x - padding - padding

        imageView.frame = imageFrame
        label.frame = labelFrame
    }

//    override public func becomeFirstResponder() -> Bool {
//        self.fxField?.becameFirstResponder()
//        OperationQueue.main.addOperation {
//            self.sendActions(for: .touchUpInside)
//        }
//       return true
//    }
//
//    override public func resignFirstResponder() -> Bool {
//        self.fxField?.resignedFirstResponder()
//        return true
//    }
//
//    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        OperationQueue.main.addOperation {
//            self.fxField?.becameFirstResponder()
//        }
//        super.touchesEnded(touches, with: event)
//    }

    // Funcional support for disclosed action sheets

//    public func presentActionSheet(title:String?, list:[String], selected:String?, from:UIViewController, completion:((_ index:Int?, _ item:String?)->Void)? ) {
//        let sheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
//        var index = 0
//        for item in list {
//            let style: UIAlertActionStyle = (item == (selected ?? "") ? .destructive : .default)
//            sheet.addAction(UIAlertAction(title: item, style: style, handler: { (action) in
//                if let completion = completion {
//                    completion(index, item)
//                } else {
//                    self.fxField?.text = item
//                }
//                self.fxField?.form?.tabNextFieldInCurrentDirection()
//            }))
//            index += 1
//        }
//        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//            completion?(nil, nil)
//        }))
//        from.present(sheet, animated: true, completion: nil)
//    }

}

/// Implements the FxBindableValue protocol for UITextViews, allowing them to be bound to FxFields.
extension FxDisclosureButton: FxBindableValue {
    /// Binds the field value to the view using Rx.
    public func bindFieldToView<E>(_ field: FxField<E>) -> Disposable? {
        return field.rx.text
            .asDriver(onErrorJustReturn: "")
            .drive(self.rx.title())
    }
    // One-way bind
    public func bindViewToField<E>(_ field: FxField<E>) -> Disposable? {
        return nil
    }
}
