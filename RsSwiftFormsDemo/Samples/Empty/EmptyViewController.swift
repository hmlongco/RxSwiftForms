//
//  ValidationViewController.swift
//  RxSwiftForms
//
//  Created by Michael Long on 3/7/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftForms

class EmptyViewController: UIViewController, Dismissible {

    var form: FxForm<String>!

    private var disposeBag = DisposeBag()

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var formStack: UIStackView!

    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupForm()
        setupSubscriptions()
        setupActions()
    }

    func setupSubscriptions() {

    }

    func setupForm() {
        
    }

    func setupActions() {
        weak var weakSelf = self
        disposeBag.bag (
            saveButton.rx.tap
                .subscribe(onNext: {  }),

            clearButton.rx.tap
                .subscribe(onNext: { weakSelf?.form.clear() }),

            cancelButton.rx.tap
                .subscribe(onNext: { weakSelf?.dismissible() })
        )
    }

}
