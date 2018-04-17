//
//  FxErrorLabel.swift
//  RxSwiftForms
//
//  Created by Michael Long on 4/4/18.
//  Copyright © 2018 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class FxErrorLabel: UILabel, FxErrorHandling {

    public var errorMessage: String? {
        didSet {
            handleErrorMessage(errorMessage)
        }
    }

    public var autoShowHide = true

    private var animatingErrorMessage = false

    public func showErrorMessage(_ message: String?) {

        guard animatingErrorMessage == false else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showErrorMessage(message)
            }
            return
        }

        let isEmpty = message?.isEmpty ?? true
        if isEmpty && isHidden {
            return
        }

        animatingErrorMessage = true
        UIView.animate(withDuration: 0.4, animations: {
            self.text = isEmpty ? nil : message
            self.isHidden = isEmpty
        }) { (done) in
            if done {
                self.animatingErrorMessage = false
            }
        }
    }

    public func handleErrorMessage(_ message: String?) {
        if autoShowHide {
            showErrorMessage(message)
        }
    }

}
