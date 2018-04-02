//
//  States.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/11/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation

struct USStates {

    let states:[(String, String)] = [
        ("Alabama","AL"),
        ("Alaska","AK"),
        ("Arizona","AZ"),
        ("Arkansas","AR"),
        ("California","CA"),
        ("Colorado","CO"),
        ("Connecticut","CT"),
        ("Delaware","DE"),
        ("Florida","FL"),
        ("Georgia","GA"),
        ("Hawaii","HI"),
        ("Idaho","ID"),
        ("Illinois","IL"),
        ("Indiana","IN"),
        ("Iowa","IA"),
        ("Kansas","KS"),
        ("Kentucky","KY"),
        ("Louisiana","LA"),
        ("Maine","ME"),
        ("Maryland","MD"),
        ("Massachusetts","MA"),
        ("Michigan","MI"),
        ("Minnesota","MN"),
        ("Mississippi","MS"),
        ("Missouri","MO"),
        ("Montana","MT"),
        ("Nebraska","NE"),
        ("Nevada","NV"),
        ("New Hampshire","NH"),
        ("New Jersey","NJ"),
        ("New Mexico","NM"),
        ("New York","NY"),
        ("North Carolina","NC"),
        ("North Dakota","ND"),
        ("Ohio","OH"),
        ("Oklahoma","OK"),
        ("Oregon","OR"),
        ("Pennsylvania","PA"),
        ("Rhode Island","RI"),
        ("South Carolina","SC"),
        ("South Dakota","SD"),
        ("Tennessee","TN"),
        ("Texas","TX"),
        ("Utah","UT"),
        ("Vermont","VT"),
        ("Virginia","VA"),
        ("Washington","WA"),
        ("West Virginia","WV"),
        ("Wisconsin","WI"),
        ("Wyoming","WY")
    ]

    var names: [String] {
        return states.map { $0.1 }
    }

    func name(fromAbbreviation abbreviation: String?) -> String? {
        guard let abbreviation = abbreviation?.uppercased() else { return nil }
        let results = states.filter { $0.1 == abbreviation }
        return results.first?.0
    }

    func abbreviation(fromName name: String?) -> String? {
        guard let name = name?.capitalized else { return nil }
        let results = states.filter { $0.0 == name }
        return results.first?.1
    }

    func index(ofAbbreviation abbreviation: String?) -> Int? {
        guard let abbreviation = abbreviation?.uppercased() else { return nil }
        return states.map { $0.1 }.index(of: abbreviation)
    }

    func index(ofName name: String?) -> Int? {
        guard let name = name?.capitalized else { return nil }
        return states.map { $0.0 }.index(of: name)
    }

}

