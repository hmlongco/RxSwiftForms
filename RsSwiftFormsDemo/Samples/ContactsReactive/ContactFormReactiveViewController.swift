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

class ContactFormReactiveViewController: UIViewController, Dismissible {

    var contact: Contact!

    var viewModel: ContactFormReactiveViewModel!
    var form: FxForm<RContactFormFields>!
 
    private var disposeBag = DisposeBag()

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var formStack: UIStackView!
    @IBOutlet weak var phoneStack: UIStackView!

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var address1Field: UITextField!
    @IBOutlet weak var address2Field: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    @IBOutlet weak var phoneMobileField: UITextField!
    @IBOutlet weak var phoneHomeField: UITextField!
    @IBOutlet weak var phoneWorkField: UITextField!
    @IBOutlet weak var phoneFaxField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailAltField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var agreementField: UISwitch!
    @IBOutlet weak var agreementLabel: UILabel!

    @IBOutlet weak var modeButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    @IBOutlet var processingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ContactFormReactiveViewModel()

        setupContactFormWithAutoBinding(contact)
        setupActions()
        setupSubscriptions()

        showProcessingSpinner(false)
     }

    #if DEBUG
    deinit {
        OperationQueue.main.addOperation {
            FxResourceTracking.status()
        }
    }
    #endif

    func setupActions() {
        viewModel.handle(save: saveButton.rx.tap.asObservable())
        viewModel.handle(hide: modeButton.rx.tap.asObservable())
        viewModel.handle(clear: clearButton.rx.tap.asObservable())
    }

    func setupSubscriptions() {
        weak var weakSelf = self
        disposeBag.bag (

            viewModel.fields[.phoneMobile]!.rx.isHidden
                .asDriver(onErrorJustReturn: false)
                .drive(onNext: { weakSelf?.togglePhoneStack($0) }),

            viewModel.fields[.agreement]!.rx.isValid
                .asDriver(onErrorJustReturn: false)
                .drive(onNext: { weakSelf?.agreementLabel.textColor = $0 ? .white : UIColor(red: 1.0, green: 0.7, blue: 0.7, alpha: 1.0) }),

            viewModel.error
                .asDriver(onErrorJustReturn: "")
                .drive(onNext: { weakSelf?.showError($0) }),

            viewModel.processing
                .asDriver(onErrorJustReturn: false)
                .drive(onNext: { weakSelf?.showProcessingSpinner($0) }),

            viewModel.saved
                .subscribe(onNext: { weakSelf?.dismissible(result: $0) }),

            cancelButton.rx.tap
                .subscribe(onNext: { weakSelf?.dismissible() })

        )
    }

    func setupContactFormWithAutoBinding(_ contact: Contact) {

        let fields = viewModel.setup(contact: contact)
        form = FxForm(fields, viewController: self, scrollView: scrollView)
            .autoBind() // demonstrate full automatic binding of fields to outlets
            .autoBindErrorColors()
            .addInputAccessoryView() // add standard input accessory view
            .addHideKeyboardGesture()

    }

    // demo functionality

    func togglePhoneStack(_ hide: Bool) {
        form.doneEditing()
        UIView.animate(withDuration: 0.4) {
            self.phoneStack.isHidden = hide
        }
    }

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

    func tagPlaceholdersWithRequired() {
        for field in form where field.isRequired {
            if let textField = field.view as? UITextField, let placeHolder = textField.placeholder {
                textField.placeholder = "\(placeHolder) (required)"
            }
        }
    }

    // support error display

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
