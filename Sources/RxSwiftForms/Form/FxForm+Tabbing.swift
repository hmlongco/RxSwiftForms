//
//  FxForm+Tabbing.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/22/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension FxForm {

    // MARK: - FxForm Tab Management

    /// Runs through our list of fields and returns the current responder, if any.
    public func currentResponder() -> UIView? {
        for field in tabOrder {
            if let view = field.view, view.isFirstResponder {
                return view
            }
        }
        return nil
    }

    public func doneEditing() {
        if let view = currentResponder() {
            _ = view.resignFirstResponder()
        }
    }

    /// Gets the current responder and tabs to the next available responder. If none found resigns current responder.
    public func tabNext() {
        if let view = currentResponder() {
            OperationQueue.main.addOperation({
                if let next = self.nextTabbedElement(view) {
                    _ = next.becomeFirstResponder()
                    self._viewScroller?.scrollIntoView(next)
                } else {
                    _ = view.resignFirstResponder()
                }
            })
        }
    }

    /// Gets the current responder and tabs to the next previous responder. If none found resigns current responder.
    public func tabPrevious() {
        if let view = currentResponder() {
            OperationQueue.main.addOperation({
                if let previous = self.previousTabbedElement(view) {
                    _ = previous.becomeFirstResponder()
                    self._viewScroller?.scrollIntoView(previous)
                } else {
                    _ = view.resignFirstResponder()
                }
            })
        }
    }

    // MARK: - FxForm Tab Internals

    internal func setupTabbedElement(_ field: FxField<E>, _ view: UIView) {
        // add field to tabbed order list
        view.fx.tabIndex = tabOrder.count
        tabOrder.append(field)
        // subscribe to textField events and update first responder status accordingly
        if let textField = view as? UITextField {
            textField.rx.controlEvent(.editingDidEndOnExit)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    if let view = self?.nextTabbedElement(view) {
                        _ = view.becomeFirstResponder()
                        self?._viewScroller?.scrollIntoView(view)
                    } else {
                        _ = textField.resignFirstResponder()
                    }
                })
                .disposed(by: _disposeBag)
        }
    }

    internal func nextTabbedElement(_ view: UIView?, step: Int = 1) -> UIView? {
        guard let index = view?.fx.tabIndex, tabOrder.indices.contains(index + step) else {
            return nil
        }
        let nextElement = tabOrder[index + step]
        if let nextView = nextElement.view, nextElement.isHidden == false && nextView.canBecomeFirstResponder {
            return nextView
        }
        return nextTabbedElement(nextElement.view, step: step)
    }

    internal func previousTabbedElement(_ view: UIView) -> UIView? {
        return nextTabbedElement(view, step: -1)
    }

}

extension FxViewAttributes {
    var tabIndex: Int {
        get { return self[FxAttribute.TABINDEX] ?? 0 }
        set { updateValue(newValue, forKey: FxAttribute.TABINDEX) }
    }
}
