//
//  FxInputAccessoryView.swift
//  FxProject
//
//  Created by Michael Long on 1/31/17.
//  Copyright © 2017 com.hmlong. All rights reserved.
//

import UIKit


public protocol FxInputAccessoryViewDelegate: class {
    func tabPrevious()
    func tabNext()
    func doneEditing()
}

public protocol FxInputAccessoryViewInterface {
    weak var accessoryDelegate:FxInputAccessoryViewDelegate? { get set }
    func updateInterface(hasPrevious:Bool, hasNext:Bool, returnType:UIReturnKeyType)
}

public class FxInputAccessoryView: UIToolbar, FxInputAccessoryViewInterface {

    public weak var accessoryDelegate:FxInputAccessoryViewDelegate?
    weak var previousButton:UIBarButtonItem?
    weak var nextButton:UIBarButtonItem?

    public init() {
        super.init(frame: CGRect.zero)
        constructAccessoryView()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func constructAccessoryView() {
        let previousButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem(rawValue: 101)!, target: self, action: #selector(tabPrevious))
        let nextButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem(rawValue: 102)!, target: self, action: #selector(tabNext))

        let items = [
            UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(doHide)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            previousButton,
            UIBarButtonItem(title: "  ", style: .plain, target: nil, action: nil),
            nextButton
        ]

        sizeToFit()
        setItems(items, animated: false)

        self.previousButton = previousButton
        self.nextButton = nextButton
    }

    public func updateInterface(hasPrevious:Bool, hasNext:Bool, returnType:UIReturnKeyType) {
        previousButton?.isEnabled = hasPrevious
        nextButton?.isEnabled = hasNext
     }

    @objc public func tabPrevious() {
        accessoryDelegate?.tabPrevious()
    }

    @objc public func tabNext() {
        accessoryDelegate?.tabNext()
    }

    @objc public func doHide() {
        accessoryDelegate?.doneEditing()
    }
}
