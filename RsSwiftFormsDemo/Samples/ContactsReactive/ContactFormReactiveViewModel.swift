//
//  ContactFormViewModel.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/5/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftForms

enum RContactFormFields : String {
    case firstName
    case lastName
    case address1
    case address2
    case city
    case state
    case zip
    case country
    case phoneMobile
    case phoneHome
    case phoneWork
    case phoneFax
    case email
    case emailAlt
    case agreement
    case gender
}

class ContactFormReactiveViewModel {

    var contact: Contact!

    let fields = FxFields<RContactFormFields>()

    var contactSaver = ContactSaver()

    var processing: Observable<Bool>!
    var error: Observable<String>!
    var saved: Observable<String>!

    let errorAgreement = "Must agree to terms."
    let errorState = "State abbreviation required"
    let errorZip = "Zip must be 5 or 9 digits long"

    private let disposeBag = DisposeBag()

    func setup(contact: Contact) -> FxFields<RContactFormFields> {

        self.contact = contact

        add(.firstName).value(contact.firstName).title("First Name").required()
        add(.lastName).value(contact.lastName).title("Last Name").required()
        add(.address1).value(contact.address1).title("Address").required().format(FxTextFormatUppercased())
        add(.address2).value(contact.address2)
        add(.city).value(contact.city).required()
        add(.state).value(contact.state).required(length: 2)
        add(.zip).value(contact.zip).required().validate(errorZip, { $0.asText.count == 5 || $0.asText.count == 10 })
        add(.country).value(contact.country)
        add(.phoneMobile).value(contact.phoneMobile).required().title("Phone").format(FxTextFormatNone())
        add(.phoneHome).value(contact.phoneHome)
        add(.phoneWork).value(contact.phoneWork)
        add(.phoneFax).value(contact.phoneFax)
        add(.email).value(contact.email).required().validate(FxRules.email())
        add(.emailAlt).value(contact.emailAlt).validate(FxRules.email())
        add(.agreement).value(contact.agreement).required().validate(errorAgreement) { $0.asBool }.message(errorAgreement)
        add(.gender).value(contact.gender)

        return fields
    }

    @discardableResult
    func add(_ id: RContactFormFields) -> FxField<RContactFormFields> {
        return fields.add(id).title(id.rawValue.capitalized)
    }

    func handle(save: Observable<Void>) {

        let validating = save
            .map { [unowned self] _ in self.fields.isValid() }

        let validationError = validating
            .filter { !$0 }
            .map { _ in "Please correct the following issues..." }

        let validated = validating
            .filter { $0 }
            .share()

        let saving = validated
            .flatMap { [unowned self] (_) -> Observable<Contact?> in
                let contact = self.buildContact()
                return self.contactSaver.save(contact).asObservable()
            }
            .catchErrorJustReturn(nil)
            .share()

        let saveError = saving
            .filter { $0 == nil }
            .map { _ in "Unable to save" }

        saved = saving
            .filter { $0 != nil }
            .map { _ in "Contact information saved." }

        error = Observable<String>
            .merge(validationError, saveError)

        processing = Observable
            .from([validated.map { _ in true }, saved.map { _ in false }, error.map { _ in false }])
            .merge()

    }

    func handle(hide: Observable<Void>) {
        hide
            .subscribe(onNext: { [unowned self] in
                [RContactFormFields.phoneMobile, .phoneHome, .phoneWork, .phoneFax].forEach { id in
                    self.fields[id]!.isHidden = !self.fields[id]!.isHidden
                }
            })
            .disposed(by: disposeBag)
    }

    func handle(clear: Observable<Void>) {
        clear
            .subscribe(onNext: { [weak self] in self?.fields.clear() })
            .disposed(by: disposeBag)
    }

    private func buildContact() -> Contact {
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
            emailAlt: fields[.emailAlt]!.asOptionalText,
            agreement: fields[.agreement]!.asBool,
            notes: contact.notes,
            gender: Gender(rawValue: fields[.gender]!.asText)
        )
    }

}

