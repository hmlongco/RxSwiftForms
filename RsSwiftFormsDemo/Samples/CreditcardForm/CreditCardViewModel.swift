//
//  CreditCardViewModel.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/21/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftForms

class CreditCardViewModel {

    let fields = FxFields<String>()

    let errorMessage = PublishSubject<String>()
    let results = PublishSubject<[String:String]>()

    func configure(_ data: [String:String]) {
        for (key, value) in data {
            add(key, value)
        }
    }

    func add(_ id: String, _ value: String) {
        let field = fields.add(id).value(value).required()
        switch id {
        case "name": field.max(length: 50)
        case "number": field.validate(FxRules.creditcard()).validate(FxRules.luhn())
        case "expires": field.max(length: 7).validate(FxRules.expiresYear4()) // "12/2018"
        case "cvc": field.max(length: 4).validate(FxRules.integer())
        default: break
        }
    }

    func save() {
        guard fields.isValid() else {
            errorMessage.onNext("Indicated fields are required or invalid...")
            return
        }
        var data = [String:String]()
        fields.forEach { data[$0.id] = $0.asText }
        results.onNext(data)
    }

}
