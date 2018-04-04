//
//  LoginFormViewModel.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/21/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftForms

enum LoginFormFields: String {
    case username
    case password
    case remember
}

class LoginFormViewModel {

    let fields = FxFields<LoginFormFields>()

    let message = BehaviorRelay(value: "Please login to your account...")
    let success = PublishSubject<String>()

    var attempts = 0

    func configureFields() -> FxFields<LoginFormFields> {
        add(.username)
        add(.password)
        add(.remember).optional()
        return fields
    }

    @discardableResult
    func add(_ id: LoginFormFields) -> FxField<LoginFormFields> {
        let title = id.rawValue.capitalized
        return fields
            .add(id)
            .title(title)
            .required()
            .message("Required")
    }

    func isValid() -> Bool {
        attempts = attempts + 1

        guard fields.isValid(), attempts > 1 else {
            message.accept("Please enter a valid username and password...")
            return false
        }

        return true
    }

    func login() {
        guard isValid() else { return }
        success.onNext("Logged In!")
    }

}
