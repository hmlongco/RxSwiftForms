//
//  FxAttributes.swift
//  FxProject
//
//  Created by Michael Long on 2/2/17.
//  Copyright © 2017 com.hmlong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public class FxBase {

    // MARK: - Attributes

    /// Keyed attributes collection allows extensions to access their own variables
    ///
    /// Normally not accessed by clients, but public in order to allow user-defined extensions to exist.
    public lazy var attributes = FxAttributes(self)

    // MARK: - Rx Extensions

    /// Keyed relay function allows extensions to create their own relay variables
    ///
    /// Normally not accessed by clients, but public in order to allow user-defined extensions to exist.
    public func relay<T>(_ key: String, _ defaultValue: T) -> BehaviorRelay<T> {
        if let relay = _relays[key] as? BehaviorRelay<T> {
            return relay
        }
        let relay = BehaviorRelay<T>(value: defaultValue)
        _relays[key] = relay
        return relay
    }

    internal var _relays = [String:Any]()
    
}
