//
//  Contact.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/5/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation
import RxSwift

enum Gender: String, Codable {
    case male
    case female
}

struct Contact: Codable {
    var firstName: String
    var lastName: String
    var address1: String
    var address2: String?
    var city: String
    var state: String
    var zip: String
    var country: String
    var phoneMobile: String?
    var phoneHome: String?
    var phoneWork: String?
    var phoneFax: String?
    var email: String
    var emailAlt: String?
    var agreement: Bool?
    var notes: String?
    var gender: Gender?
}

struct ContactSaver {
    func save(_ contact: Contact) -> Single<Contact?> {
        return Single.create(subscribe: { (single) -> Disposable in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                single(.success(contact))
            })
            return Disposables.create()
        })
    }
}

extension Contact {
    static func testContact0() -> Contact {
        return Contact(
            firstName: "",
            lastName: "",
            address1: "",
            address2: nil,
            city: "",
            state: "",
            zip: "",
            country: "",
            phoneMobile: nil,
            phoneHome: nil,
            phoneWork: nil,
            phoneFax: nil,
            email: "",
            emailAlt: nil,
            agreement: false,
            notes: nil,
            gender: nil
        )
    }
    static func testContact1() -> Contact {
        return Contact(
            firstName: "Michael",
            lastName: "Long",
            address1: "2310 S 178th",
            address2: nil,
            city: "Omaha",
            state: "NE",
            zip: "68130",
            country: "US",
            phoneMobile: "303-895-8005",
            phoneHome: nil,
            phoneWork: nil,
            phoneFax: nil,
            email: "mail@mail.com",
            emailAlt: nil,
            agreement: false,
            notes: nil,
            gender: .male
        )
    }
    static func testContact2() -> Contact {
        return Contact(
            firstName: "Michael",
            lastName: "Long",
            address1: "2310 S 178th",
            address2: nil,
            city: "",
            state: "NE",
            zip: "68130",
            country: "US",
            phoneMobile: "303-895-8005",
            phoneHome: nil,
            phoneWork: nil,
            phoneFax: nil,
            email: "mail@mail.com",
            emailAlt: nil,
            agreement: false,
            notes: nil,
            gender: nil
        )
    }
}

enum MyError: Error {
    case fail
    case validation
    case application
}
