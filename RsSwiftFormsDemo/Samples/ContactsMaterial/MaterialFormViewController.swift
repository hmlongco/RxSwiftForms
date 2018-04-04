//
//  MirrorFormViewController
//  Fox Project
//
//  Created by Michael Long on 1/5/17.
//  Copyright © 2018 com.hmlong. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MaterialFormViewController: UIViewController, Dismissible {

    var contact: Contact!
    
    var viewModel = MaterialViewModel()
    var form: FxForm<ContactFormFields>!

    private var disposeBag = DisposeBag()

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var formStack: UIStackView!
    @IBOutlet var processingView: UIView!
    
    @IBOutlet weak var firstNameField: FxTextField!
    @IBOutlet weak var lastNameField: FxTextField!
    @IBOutlet weak var address1Field: FxTextField!
    @IBOutlet weak var address2Field: FxTextField!
    @IBOutlet weak var cityField: FxTextField!
    @IBOutlet weak var stateField: FxTextField!
    @IBOutlet weak var zipField: FxTextField!
    @IBOutlet weak var emailField: FxTextField!
    @IBOutlet weak var emailValidField: FxTextField!
    @IBOutlet weak var countryField: FxTextField!
    @IBOutlet weak var agreementField: UISwitch!
    @IBOutlet weak var agreementLabel: UILabel!

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var errorHeight: NSLayoutConstraint!

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupContactForm()
        setupSubscriptions()
        setupActions()

        setupStatesPicker()

        showProcessingSpinner(false)
    }

    #if DEBUG
    deinit {
        OperationQueue.main.addOperation {
            FxResourceTracking.status()
        }
    }
    #endif

    func setupContactForm() {
        let fields = viewModel.setup(contact: contact)

        form = FxForm(fields, viewController: self, scrollView: scrollView)

            // demonstrate autobinding with full control over features that are automatically bound
            .autoBind() { field in
                return [] // no exclusions, bind everything
            }

            .autoValidateOnExit()
            .addInputAccessoryView()
            .addHideKeyboardGesture()

        tagOptionalPlaceholders()
        swapStyles()
        zipField.maskFormat = "99999-9999"
    }

    func setupSubscriptions() {
        weak var weakSelf = self
        disposeBag.bag(
            viewModel.fields[.agreement]!.rx.isValid
                .asDriver(onErrorJustReturn: false)
                .drive(onNext: { weakSelf?.agreementLabel.textColor = $0 ? .gray : .red }),

            viewModel.message
                .asDriver(onErrorJustReturn: "")
                .drive(onNext: { weakSelf?.showError($0) })
        )
    }

    func setupActions() {
        weak var weakSelf = self
        disposeBag.bag (
            saveButton.rx.tap
                .subscribe(onNext: {
                    weakSelf?.form.doneEditing()
                    weakSelf?.save()
                }),

            clearButton.rx.tap
                .subscribe(onNext: {
                    weakSelf?.form.doneEditing()
                    weakSelf?.viewModel.clear()
                }),

            cancelButton.rx.tap
                .subscribe(onNext: {
                    weakSelf?.form.doneEditing()
                    weakSelf?.dismissible()
                })
        )
    }

    func setupStatesPicker() {
        let states = viewModel.states()
        let statesPicker = UIPickerView()

        stateField.inputView = statesPicker
        stateField.disclosureImage = UIImage(named: "downarrow")

        disposeBag.bag (
            Observable.just(states.names)
                .bind(to: statesPicker.rx.itemTitles) { _, item in
                    return item
            },

            statesPicker.rx.itemSelected
                .subscribe({ [weak self] selection in
                    self?.stateField.text = states.states[selection.element?.row ?? 0].1
                })
        )

        let row = states.index(ofAbbreviation: stateField.text) ?? 0
        statesPicker.selectRow(row, inComponent: 0, animated: false)
    }

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

    func tagOptionalPlaceholders() {
        for field in form.tabOrder where !field.isRequired {
            if let textField = field.view as? UITextField, let placeHolder = textField.placeholder {
                textField.placeholder = "\(placeHolder) (optional)"
            }
        }
    }

    // support error display

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

    func showError(_ message:String = "Indicated fields are required or invalid...") {
        hideErrorMessage() {
            if !message.isEmpty {
                self.scrollView.contentOffset = CGPoint.zero
                self.errorLabel.alpha = 0.0
                self.errorLabel.text = message
                UIView.animate(withDuration: 0.4) {
                    self.errorLabel.alpha = 1.0
                    self.errorHeight.isActive = false
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    func hideErrorMessage(_ completion:@escaping (()->Void) = {}) {
        if !errorHeight.isActive {
            UIView.animate(withDuration: 0.2, animations: {
                self.errorLabel.alpha = 0.0
                self.errorHeight.isActive = true
                self.view.layoutIfNeeded()
            }, completion: { (done) in
                if done {
                    completion()
                }
            })
        } else {
            completion()
        }
    }

    static var material = true
    func swapStyles() {
        if !MaterialFormViewController.material {
            title = "Meta Form"
            scrollView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        }
        for field in form.fields {
            if let textfield = field.view as? FxTextField {
                if MaterialFormViewController.material {
                    textfield.add(behavior: MetaTextDecoratorUnderline(color: textfield.tintColor, errorColor: .red))
                } else {
                    textfield.add(behavior: MetaTextDecoratorBorder(color: .lightGray, editingColor: textfield.tintColor, errorColor: .red))
                }
            }
        }
        MaterialFormViewController.material = !MaterialFormViewController.material
    }
}
