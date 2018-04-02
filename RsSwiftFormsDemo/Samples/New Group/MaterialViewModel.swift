//
//  ContactFormViewModel.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/5/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import RxSwift
import RxCocoa

class MaterialViewModel {

    var contact: Contact!

    let fields = FxFields<ContactFormFields>()

    var contactSaver = ContactSaver()

    var message = PublishSubject<String>()

    let successMessage = "Contact information saved."
    let errorAgreement = "Must agree to terms."
    let errorState = "State abbreviation required"
    let errorZip = "Zip must be 5 or 9 digits long"

    private let disposeBag = DisposeBag()

    func setup(contact: Contact) -> FxFields<ContactFormFields> {

        self.contact = contact

        add(.firstName).value(contact.firstName).title("First Name").required()
        add(.lastName).value(contact.lastName).title("Last Name").required()
        add(.address1).value(contact.address1).title("Address").required().format(FxTextFormatUppercased())
        add(.address2).value(contact.address2)
        add(.city).value(contact.city).required()
        add(.state).value(contact.state).required(length: 2)
        add(.zip).value(contact.zip).required().max(length: 10).validate(errorZip) { $0.asText.count == 5 || $0.asText.count == 10 }
        add(.country).value(contact.country)
        add(.phoneMobile).value(contact.phoneMobile).required().title("Phone")
        add(.phoneHome).value(contact.phoneHome)
        add(.phoneWork).value(contact.phoneWork)
        add(.phoneFax).value(contact.phoneFax).hidden(true)
        add(.email).value(contact.email).required().validate(FxRules.email())
        add(.emailValid).required().value(contact.email).title("Validation Email").validate(FxRules.email())
        add(.agreement).value(false).required()
        add(.gender).value(contact.gender)

        fields[.emailValid]?.validate("Emails must match.") { [unowned fields] value in
            return fields[.email]!.asText == value.asText
        }

        return fields
    }

    @discardableResult
    func add(_ id: ContactFormFields) -> FxField<ContactFormFields> {
        return fields.add(id).title(id.rawValue.capitalized)
    }

    func hide() {
        [ContactFormFields.phoneMobile, .phoneHome, .phoneWork, .phoneFax].forEach { id in
            self.fields[id]!.isHidden = !self.fields[id]!.isHidden
        }
    }

    func clear() {
        fields.clear()
    }

    func states() -> USStates {
        return USStates()
    }

    func save() -> Single<String> {

        guard fields.isValid() else {
            let errors = fields.errorMessages
            let max = 2
            if errors.count > (max+1) {
                let remaining = errors.count-max
                let msg = errors.prefix(max).joined(separator: "\n") + "\nPlus \(remaining) other issues require attention..."
                message.onNext(msg)
            } else {
                message.onNext(errors.joined(separator: "\n"))
            }
            return Single.error(MyError.validation)
        }

        guard let contact = self.buildContact() else {
            message.onNext("Unable to save")
            return Single.error(MyError.application)
        }

        return contactSaver.save(contact)
            .do(onError: { (_) in
                self.message.onNext("Unable to save")
            })
            .flatMap({ (_) in
                return Single.just(self.successMessage)
            })

    }

    private func buildContact() -> Contact? {
        return Contact(
            firstName: fields[.firstName]!.asText,
            lastName: fields[.lastName]!.asText,
            address1: fields[.address1]!.asText,
            address2: fields[.address2]!.asText,
            city: fields[.city]!.asText,
            state: fields[.state]!.asText,
            zip: fields[.zip]!.asText,
            country: fields[.country]!.asText,
            phoneMobile: fields[.phoneMobile]!.asText,
            phoneHome: fields[.phoneHome]!.asOptionalText,
            phoneWork: fields[.phoneWork]!.asOptionalText,
            phoneFax: fields[.phoneFax]!.asOptionalText,
            email: fields[.email]!.asText,
            emailAlt: fields[.emailValid]!.asOptionalText,
            agreement: fields[.agreement]!.asBool,
            notes: contact.notes,
            gender: Gender(rawValue: fields[.gender]!.asText)
        )
    }

}
