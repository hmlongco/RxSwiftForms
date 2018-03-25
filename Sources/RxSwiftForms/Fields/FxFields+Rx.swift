//
//  FxFields+Rx.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/25/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import RxSwift
import RxCocoa

public extension FxFields {

    internal func setupObservables() {
        weak var weakself = self
        _changed = Observable.deferred { () -> Observable<Bool> in
            let obserables = weakself?.list.map { $0.rx.isChanged.asObservable() } ?? []
            return Observable<Bool>
                .combineLatest(obserables) { _ in true }
                .skip(1) // subscribing will fire so skip until actual event occurs
        }

        _valid = Observable.deferred { () -> Observable<Bool> in
            let obserables = weakself?.list.map { $0.rx.isValid.asObservable() } ?? []
            return Observable<Bool>
                .combineLatest(obserables) { $0.reduce(true) { $0 && $1 } }
        }
    }

}

public struct FxFieldsReactiveBase<E:Hashable> {

    weak var base: FxFields<E>!

    init(_ base: FxFields<E>) {
        self.base = base
    }

    /// Observable fires when any managed field is changed.
    public var isChanged: Observable<Bool> {
        return base._changed.share()
    }

    /// Observable is true when all managed fields are valid.
    public var isValid: Observable<Bool> {
        return base._valid.share()
    }

    /// May be used to force a validation sequence to occur on all managed fields.
    public var validate: Binder<Void> {
        return Binder<Void>(base, binding: { (base, _) in
            base.isValid()
        })
    }

}
