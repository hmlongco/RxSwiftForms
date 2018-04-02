//
//  RxSwift+Extensions.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/6/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import RxSwift
import RxCocoa

extension DisposeBag {

    public func bag(_ disposables: Disposable...) {
        disposables.forEach { self.insert($0) }
    }
    
}
