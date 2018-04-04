//
//  MaterialReflectionViewModel.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/5/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftForms

class MaterialReflectionViewModel: MaterialViewModel {

    override func setup(contact: Contact) -> FxFields<ContactFormFields> {

        self.contact = contact

        Mirror(reflecting: contact).children.forEach { (key, value) in
            if let key = key, let id = ContactFormFields(rawValue: key) {
                let field = self.fields.add(id).required()
                if let value = value as? String {
                    field.value(value)
                }
            }
        }

        fields.forEach { f in
            switch f.id {
            case .address2, .phoneMobile, .phoneHome, .phoneWork, .phoneFax, .gender:
                f.optional()
            case .state:
                f.required(length: 2)
            case .zip:
                f.validate(errorZip, { $0.asText.count == 5 || $0.asText.count == 10 })
            case .email:
                f.validate(FxRules.email()).max(length: 100)
            case .emailAlt:
                f.optional().validate(FxRules.email()).max(length: 100)
            case .agreement:
                f.validate(errorAgreement) { $0.asBool }
            default:
                f.max(length: 40)
            }
        }

        return fields
    }

}

