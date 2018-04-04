//
//  CreditCardViewController.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/7/17.
//  Copyright © 2018 com.hmlong. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftForms

class CreditCardViewController: UIViewController, Dismissible {

    var data: [String:String] = ["name":"Michael Long", "number":"4292 3929 3939 1231", "expires":"09/2020", "cvc":"891"]

    let viewModel = CreditCardViewModel()
    var form: FxForm<String>!

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var nameField: FxTextField!
    @IBOutlet weak var numberField: FxTextField!
    @IBOutlet weak var expiresField: FxTextField!
    @IBOutlet weak var cvcField: FxTextField!

    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.configure(data)
        
        setupForm()
        setupSubscriptions()
        setupActions()
        setupTextFields()
    }

    #if DEBUG
    deinit {
        OperationQueue.main.addOperation {
            FxResourceTracking.status()
        }
    }
    #endif

    func setupForm() {
        form = FxForm(viewModel.fields, viewController: self, scrollView: scrollView)
            .autoBind()
            .autoBindErrorColors()
            .autoNext()
            .addInputAccessoryView()
    }

    func setupSubscriptions() {
        weak var weakSelf = self
        disposeBag.bag (
            viewModel.errorMessage
                .subscribe(onNext: { (message) in
                    OperationQueue.main.addOperation {
                        weakSelf?.label.text = message
                    }
                }),

            viewModel.results
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { (data) in
                    let message = "Your order is on its way even now as we speak."
                    weakSelf?.dismissible(result: (message, data))
                })
        )
    }

    func setupActions() {
        weak var weakSelf = self
        disposeBag.bag (
            orderButton.rx.tap
                .subscribe(onNext: {
                    weakSelf?.form.doneEditing()
                    weakSelf?.viewModel.save()
                }),

            clearButton.rx.tap
                .subscribe(onNext: {
                    weakSelf?.form.doneEditing()
                    UIView.animate(withDuration: 0.4) {
                        weakSelf?.form.clear()
                    }
                }),

            cancelButton.rx.tap
                .subscribe(onNext: {
                    weakSelf?.form.doneEditing()
                    weakSelf?.dismissible()
                })
        )
    }


    func setupTextFields() {
        numberField.maskFormat = "9999 9999 9999 9999999"
        expiresField.maskFormat = "99/9999"
        cvcField.maskFormat = "9999"
    }

}
