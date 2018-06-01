//
//  ValidationViewModel.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/8/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

class ValidationViewModel {

    var fields = FxFields<String>()

    func setupFields() {
        fields.add("required")
            .placeholder("Sample")
            .required()
            .message("Required.")

        fields.add("creditcard")
            .validate(FxRules.creditcard())
            .placeholder("0000 0000 0000 0000")
            .keyboardType(.numbersAndPunctuation)

        fields.add("currency")
            .placeholder("0.00")
            .validate(FxRules.currency())
            .keyboardType(.decimalPad)

        fields.add("custom")
            .placeholder("Test")
            .validate("Anything other than 'Test' is invalid", { $0.asText.lowercased() == "test" })

        fields.add("cvc")
            .title("CVC")
            .placeholder("000")
            .validate(FxRules.cvc())
            .keyboardType(.decimalPad)

        fields.add("email")
            .title("Email Address")
            .placeholder("sample@sample.com")
            .validate(FxRules.email())
            .keyboardType(.emailAddress)

        fields.add("decimal")
            .placeholder("0.0")
            .validate(FxRules.decimal())
            .keyboardType(.decimalPad)

        fields.add("expires2")
            .placeholder("mm/yy")
            .validate(FxRules.expiresYear2())
            .keyboardType(.numbersAndPunctuation)

        fields.add("expires4")
            .placeholder("mm/yyyy")
            .validate(FxRules.expiresYear4())
            .keyboardType(.numbersAndPunctuation)

        fields.add("integer")
            .placeholder("0")
            .validate(FxRules.integer())
            .keyboardType(.decimalPad)

        fields.add("ssn")
            .title("SSN")
            .placeholder("000-00-0000")
            .validate(FxRules.ssn())
            .keyboardType(.numbersAndPunctuation)

        fields.add("phone")
            .placeholder("000-000-0000")
            .validate(FxRules.phone())
            .keyboardType(.numbersAndPunctuation)

        fields.add("zip")
            .placeholder("00000")
            .validate(FxRules.zipcode())
            .keyboardType(.decimalPad)

        fields.add("zip4")
            .title("Zip Plus 4")
            .placeholder("00000-0000")
            .validate(FxRules.zipPlusFour())
            .keyboardType(.numbersAndPunctuation)
    }


}
