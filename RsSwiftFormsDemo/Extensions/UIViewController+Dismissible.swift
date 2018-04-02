//
//  UIViewController+Dismissable.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/6/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit

public protocol Dismissible where Self : UIViewController {
    func dismissible<T>(result: T?)
    func dismissible()
}

public protocol DismissibleHandling {

    func handleDismissible<V:UIViewController,T>(_ type: V.Type,
                                                 completion: @escaping DismissibleCompletionBlock<V,T>) -> Bool

    func handleDismissible<V:UIViewController,T>(_ type: V.Type, setup: DismissibleSetupBlock<V>,
                                                 completion: @escaping DismissibleCompletionBlock<V,T>) -> Bool
    
}

public typealias DismissibleSetupBlock<V:UIViewController> = (_ vc: V) -> ()
public typealias DismissibleCompletionBlock<V:UIViewController,T> = (_ vc: V, _ result: T?) -> ()

extension UIViewController: DismissibleHandling {

    @discardableResult
    public func handleDismissible<V:UIViewController,T>(_ type: V.Type = V.self, completion: @escaping DismissibleCompletionBlock<V,T>) -> Bool {

        // disambiguation of navigation controller makes using in PrepareForSegue much easier
        let destination = (self as? UINavigationController)?.viewControllers.first ?? self

        // if destination not dismissible then leave
        guard let vc = destination as? V, vc is Dismissible else {
            return false
        }

        // box generic completion type as Any to avoid generic type constriant issues
        vc.dismissibleStorage = { (vc, result ) in
            guard let vc = vc as? V else {
                return
            }
            if let result = result {
                if let result = result as? T {
                    completion(vc, result)
                } else {
                    fatalError("Value returned by viewController was wrong type.")
                }
            } else {
                completion(vc, nil)
            }
        }

        return true
    }

    @discardableResult
    public func handleDismissible<V:UIViewController,T>(_ type: V.Type = V.self, setup: DismissibleSetupBlock<V>,
                                                        completion: @escaping DismissibleCompletionBlock<V,T>) -> Bool {

        // disambiguation of navigation controller makes using in PrepareForSegue much easier
        let destination = (self as? UINavigationController)?.viewControllers.first ?? self

        // if destination not dismissible then leave
        guard let vc = destination as? V, vc is Dismissible else {
            return false
        }

        // setup parameters
        setup(vc)

        // box generic completion type as Any to avoid generic type constriant issues
        vc.dismissibleStorage = { (vc, result ) in
            guard let vc = vc as? V else {
                return
            }
            if let result = result {
                if let result = result as? T {
                    completion(vc, result)
                } else {
                    fatalError("Value returned by viewController was wrong type.")
                }
            } else {
                completion(vc, nil)
            }
        }

        return true
    }

}

public extension Dismissible {

    func dismissible<T>(result: T?) {
        guard let completion = dismissibleStorage else {
            fatalError("Completion block not set by handleDismissible.")
        }
        completion(self, result)
    }

    func dismissible() {
        guard let completion = dismissibleStorage else {
            fatalError("Completion block not set by handleDismissible.")
        }
        completion(self, nil)
    }

}

fileprivate typealias DismissibleCompletionBox = (_ vc: UIViewController?, _ result: Any?) -> ()

fileprivate extension UIViewController {

    fileprivate var dismissibleStorage: DismissibleCompletionBox? {
        get { return objc_getAssociatedObject(self, &DismissibleStorageHandle) as? DismissibleCompletionBox }
        set { objc_setAssociatedObject(self, &DismissibleStorageHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

}

internal var DismissibleStorageHandle:UInt8 = 0
