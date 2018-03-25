//
//  FxScrolling
//  FxProject
//
//  Created by Michael Long on 2/9/17.
//  Copyright © 2018 com.hmlong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// Defines protocol that manages the scrollview and adjusts for keyboard show/hide events.
public protocol FxViewScrolling {
    var scrollView: UIScrollView? { get }
    func scrollIntoView(_ view: UIView)
}

/// Manages the scrollview and adjusts the content area for keyboard show/hide events.
public class FxScrollingService: FxViewScrolling {

    // MARK: - Properties
    
    public weak var scrollView: UIScrollView?

    public var extraPadding: CGFloat = 50.0

    private var disposeBag = DisposeBag()

    // MARK: - Lifecycle

    public init (scrollView: UIScrollView) {
        self.scrollView = scrollView
        // Adding notifies on keyboard appearance

        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillShow)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (notification) in
                self?.keyboardWillShow(notification)
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillHide)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (notification) in
                self?.keyboardWillBeHidden(notification)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Scrolling

    public func scrollIntoView(_ view: UIView) {
        if let scrollView = scrollView, let frame = view.superview?.convert(view.frame, to: scrollView), !scrollView.frame.contains(frame.origin) {
            scrollView.scrollRectToVisible(frame, animated: true)
        }
    }

    // MARK: - Keyboard
    
    func keyboardWillShow(_ notification: Notification)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let info: NSDictionary = notification.userInfo! as NSDictionary
            let keyboardHeight = ((info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size.height)! + self.extraPadding

            let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight, 0.0)
            self.scrollView?.contentInset = contentInsets
            self.scrollView?.scrollIndicatorInsets = contentInsets
        }
    }

    func keyboardWillBeHidden(_ notification: Notification)
    {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }

}
