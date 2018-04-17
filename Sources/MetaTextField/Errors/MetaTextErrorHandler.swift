//
//  MetaTextErrorHandler.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/19/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

open class MetaTextErrorHandler: MetaTextBehaviorErrorHandling {

    public static let name = "MetaTextErrorHandler"

    public var name: String? { return nil } // Allow more than one
    public var priority: MetaTextPriority { return .low }

    internal weak var textField: MetaTextField?
    internal let handler: (_ textField: MetaTextField, _ message: String?) -> Void

    public init(_ handler: @escaping (_ textField: MetaTextField, _ message: String?) -> Void) {
        self.handler = handler
    }

    public func add(to textField: MetaTextField) -> Bool {
        self.textField = textField
        return true
    }

    public func handleErrorMessage(_ message: String?) {
        guard let textField = textField else { return }
        handler(textField, message)
    }

}
