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

class ValidationViewController: UIViewController, Dismissible {

    var viewModel = ValidationViewModel()
    
    var form: FxForm<String>!

    private var disposeBag = DisposeBag()

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var formStack: UIStackView!

    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.setupFields()

        setupForm()
        setupActions()
   }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.form.fields["required"]?.placeholder = "I mean it!"
        }
    }

    #if DEBUG
    deinit {
        OperationQueue.main.addOperation {
            FxResourceTracking.status()
        }
    }
    #endif


    func setupForm() {
        let fields = viewModel.fields
        form = FxForm(fields, viewController: self, scrollView: scrollView)
        
        for f in fields {

            f.title = f.title ?? f.key.capitalized

            let fieldStack = UIStackView()
            fieldStack.axis = .vertical
            fieldStack.distribution = .equalSpacing

            let label = UILabel()
            label.font = UIFont.preferredFont(forTextStyle: .caption1)
            label.text = f.title
            label.textColor = navigationController?.navigationBar.barTintColor
            fieldStack.addArrangedSubview(label)

            let textField = FxMaterialTextField()
            textField.keyboardType = f.keyboardType ?? .default
            textField.placeholder = f.placeholder
            textField.tintColor = .gray
            fieldStack.addArrangedSubview(textField)

            formStack.addArrangedSubview(fieldStack)

            form.bind(f.id, textField)
        }

        form.autoValidateOnExit()
            .addInputAccessoryView()
            .addHideKeyboardGesture()
    }

    func setupActions() {
        weak var weakSelf = self
        disposeBag.bag (
            saveButton.rx.tap
                .subscribe(onNext: {
                    if weakSelf?.form.fields.isValid() ?? false {
                        weakSelf?.dismissible(result: "All validation rules passed.")
                    }
                }),

            clearButton.rx.tap
                .subscribe(onNext: { weakSelf?.form.clear() }),

            cancelButton.rx.tap
                .subscribe(onNext: { weakSelf?.dismissible() })
        )
    }

}
