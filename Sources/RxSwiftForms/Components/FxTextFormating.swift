//
//  FxTextFormating.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/21/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import Foundation

/// Protocol used to implement custom text formatters for FxField's.
public protocol FxTextFormatting {
    func string(from input: String) -> String
}

/// Implements closure-based text formatter for FxField's.
public struct FxTextFormat: FxTextFormatting {
    var format: (String) -> String
    public init(_ format: @escaping (String) -> String) {
        self.format = format
    }
    public func string(from input: String) -> String {
        return format(input)
    }
}

/// Implements simple capitalized text formatter for FxField's.
public struct FxTextFormatCapitalized: FxTextFormatting {
    public func string(from input: String) -> String {
        return input.localizedCapitalized
    }
}

/// Implements simple lowercase text formatter for FxField's.
public struct FxTextFormatLowercased: FxTextFormatting {
    public func string(from input: String) -> String {
        return input.localizedLowercase
    }
}

/// Implements a passthrough formatter that does no formatting.
public struct FxTextFormatNone: FxTextFormatting {
    public func string(from input: String) -> String {
        return input
    }
}

/// Implements simple uppercase text formatter for FxField's.
public struct FxTextFormatUppercased: FxTextFormatting {
    public func string(from input: String) -> String {
        return input.localizedUppercase
    }
}
