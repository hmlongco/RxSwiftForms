//
//  FxInputAccessoryViewHideNext.swift
//  FoxProject
//
//  Created by Michael Long on 2/20/17.
//  Copyright © 2017 com.hmlong. All rights reserved.
//

import UIKit

open class FxInputAccessoryViewHideNext: FxInputAccessoryView {

    override func constructAccessoryView() {
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(tabNext))

        let items = [
            UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(doHide)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            nextButton
        ]

        sizeToFit()
        setItems(items, animated: false)

        self.nextButton = nextButton
    }

    override open func updateInterface(hasPrevious:Bool, hasNext:Bool, returnType:UIReturnKeyType) {
        switch returnType {
        case .`continue`: nextButton?.title = "Continue"
        case .done: nextButton?.title = "Done"
        case .emergencyCall: nextButton?.title = "Call"
        case .go: nextButton?.title = "Go"
        case .google: nextButton?.title = "Google"
        case .join: nextButton?.title = "Join"
        case .route: nextButton?.title = "Route"
        case .search: nextButton?.title = "Search"
        case .send: nextButton?.title = "Send"
        case .yahoo: nextButton?.title = "Yahoo"
        default: nextButton?.title = "Next"
        }
    }

}
