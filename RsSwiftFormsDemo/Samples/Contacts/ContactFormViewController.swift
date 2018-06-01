//
//  ContactFormViewController
//  Fox Project
//
//  Created by Michael Long on 1/5/17.
//  Copyright © 2018 com.hmlong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ContactFormViewController: UIViewController, Dismissible {

    var contact: Contact!

    var viewModel: ContactFormViewModel!
    var form: FxForm<ContactFormFields>!

    private var disposeBag = DisposeBag()

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var formStack: UIStackView!
    @IBOutlet weak var phoneStack: UIStackView!

    @IBOutlet weak var firstNameField: FxTextField!
    @IBOutlet weak var lastNameField: FxTextField!
    @IBOutlet weak var address1Field: FxTextField!
    @IBOutlet weak var address2Field: FxTextField!
    @IBOutlet weak var cityField: FxTextField!
    @IBOutlet weak var stateField: FxTextField!
    @IBOutlet weak var zipField: FxTextField!
    @IBOutlet weak var phoneMobileField: FxTextField!
    @IBOutlet weak var phoneHomeField: FxTextField!
    @IBOutlet weak var phoneWorkField: FxTextField!
    @IBOutlet weak var phoneFaxField: FxTextField!
    @IBOutlet weak var emailField: FxTextField!
    @IBOutlet weak var emailAltField: FxTextField!
    @IBOutlet weak var countryField: FxTextField!
    @IBOutlet weak var agreementField: UISwitch!
    @IBOutlet weak var agreementLabel: UILabel!

    @IBOutlet weak var modeButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    @IBOutlet var processingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ContactFormViewModel()

        setupContactFormWithAutoBindingAndOverrides(contact)
        setupSubscriptions()
        setupActions()

        showProcessingSpinner(false)
    }

    #if DEBUG
    deinit {
        OperationQueue.main.addOperation {
            FxResourceTracking.status()
        }
    }
    #endif

    func setupSubscriptions() {
        weak var weakSelf = self
        disposeBag.bag (
            viewModel.fields[.phoneMobile]!.rx.isHidden
                .asDriver(onErrorJustReturn: false)
                .drive(onNext: { weakSelf?.togglePhoneStack($0) }),

            viewModel.message
                .asDriver(onErrorJustReturn: "")
                .drive(onNext: { weakSelf?.showError($0) })
        )
    }

    func setupActions() {
        weak var weakSelf = self
        disposeBag.bag (
            saveButton.rx.tap
                .subscribe(onNext: { weakSelf?.save() }),

            modeButton.rx.tap
                .subscribe(onNext: { weakSelf?.viewModel.hide() }),

            clearButton.rx.tap
                .subscribe(onNext: { weakSelf?.viewModel.clear() }),

            cancelButton.rx.tap
                .subscribe(onNext: { weakSelf?.dismissible() })
        )
    }

    func setupContactFormWithAutoBindingAndOverrides(_ contact: Contact) {

        let fields = viewModel.setup(contact: contact)
        form = FxForm(fields, viewController: self, scrollView: scrollView)

            // demonstrate autobinding with custom override for specific field
            .autoBind() { f in
                switch f.id {
                case .agreement:
                    // from field to view
                    f.rx.bool
                        .bind(to: self.agreementField.rx.isOn)
                        .disposed(by: self.disposeBag)
                    // from view to field
                    self.agreementField.rx.isOn
                        .bind(to: f.rx.bool)
                        .disposed(by: self.disposeBag)
                    // bind error to label instead of view
                    f.rx.isValid
                        .asDriver(onErrorJustReturn: false)
                        .drive(onNext: { [weak self] valid in
                            self?.agreementLabel.textColor = valid ? .white : UIColor(red: 1.0, green: 0.7, blue: 0.7, alpha: 1.0)
                        })
                        .disposed(by: self.disposeBag)
                    return [.fieldToView, .viewToField, .error]
                default:
                    return []
                }
            }
            .autoValidateOnExit()  // demonstrate automatic validation when leaving text fields
            .addInputAccessoryView() // add custom input accessory view
            .addHideKeyboardGesture()

        setupTextFields()
    }

    // demo functionality

    func save() {
        weak var weakSelf = self
        showProcessingSpinner(true)
        viewModel.save()
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (message) in
                weakSelf?.dismissible(result: message)
            }, onDisposed: {
                weakSelf?.showProcessingSpinner(false)
            })
            .disposed(by: disposeBag)
    }

    func togglePhoneStack(_ hide: Bool) {
        form.doneEditing()
        UIView.animate(withDuration: 0.4) {
            self.phoneStack.isHidden = hide
        }
    }

    func setupTextFields() {
        for field in form {
            if let meta = field.view as? MetaTextField {
                meta.add(behavior: MetaTextErrorBackgoundColor(UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 1.0)))
            }
        }
        for field in form where !field.isRequired {
            if let textField = field.view as? FxTextField, let placeHolder = textField.placeholder {
                textField.placeholder = "\(placeHolder) (optional)"
            }
        }
        zipField.maskFormat = "99999-9999"
    }

    // some support functions that would probably be common to the app

    func showProcessingSpinner(_ show: Bool) {
        if show {
            if processingView.superview == nil {
                processingView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(processingView)
                processingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                processingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
                processingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                processingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            }
        } else if processingView.superview != nil {
            processingView.removeFromSuperview()
        }
    }

    func showError(_ message: String = "Indicated fields are required or invalid...") {
        hideErrorMessage() {
            if !message.isEmpty {
                UIView.animate(withDuration: 0.4) {
                    let view = FxErrorMessageView(with: message)
                    self.formStack.insertArrangedSubview(view, at: 0)
                    view.layer.cornerRadius = 5
                    view.isHidden = false
                    self.scrollView.contentOffset = CGPoint.zero
                }
            }
        }
    }

    func hideErrorMessage(_ completion:@escaping (()->Void) = {}) {
        if let errorMessageView = self.formStack.arrangedSubviews.first as? FxErrorMessageView {
            UIView.animate(withDuration: 0.2, animations: {
                errorMessageView.isHidden = true
            }, completion: { (done) in
                if done {
                    errorMessageView.removeFromSuperview()
                    completion()
                }
            })
        } else {
            completion()
        }
    }
}
