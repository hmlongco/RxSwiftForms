//
//  LoginFormViewController.swift
//  RxSwiftForms
//
//  Created by Michael Long on 1/27/17.
//  Copyright © 2018 com.hmlong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginFormViewController: UIViewController {

    var viewModel = LoginFormViewModel()
    var form: FxForm<LoginFormFields>!

    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var userTextField: FxMaterialTextField!
    @IBOutlet weak var pwTextField: FxMaterialTextField!
    @IBOutlet weak var loginButton: UIButton!

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareTextFields()

        let fields = viewModel
            .configureFields()

        form = FxForm(fields, viewController: self, scrollView: scrollView)

            // demonstrate manual binding when enumeration rawvalue doesn't match iboutlet names
            .bind(.username, userTextField)
            .bind(.password, pwTextField)

            .autoValidateOnChange() // demonstrate automatic validation on any field change

        setupSubscriptions()
        
        loginButton.isEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    #if DEBUG
    deinit {
        OperationQueue.main.addOperation {
            FxResourceTracking.status()
        }
    }
    #endif

    func prepareTextFields() {
        [userTextField, pwTextField].forEach { (f) in
            f?.showErrorMessages = false
            f!.errorColor = .white
            f!.underlineColor = .white
        }

        let show = UIImage(named:"visibilityOnLight")
        let hide = UIImage(named:"visibilityOffLight")
        pwTextField.add(behavior: MetaTextDecoratorShowPassword(showImage: show, hideImage: hide))
    }

    func setupSubscriptions() {

        form.fields.rx.isValid
            .observeOn(MainScheduler.instance)
            .skip(1) // subscribing will fire so skip until actual event occurs
            .debug()
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.message
            .observeOn(MainScheduler.instance)
            .bind(to: message.rx.text)
            .disposed(by: disposeBag)

        viewModel.success
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (message) in self?.success(message) })
            .disposed(by: disposeBag)

    }

    func success(_ message: String) {
        let alert = UIAlertController(title: "Success", message: "You're now logged in!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
            self.navigationController?.dismiss(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        topLayoutConstraint.constant = view.bounds.size.height / 6
        super.viewDidLayoutSubviews()
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        form.doneEditing()
        viewModel.login()
    }

    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

