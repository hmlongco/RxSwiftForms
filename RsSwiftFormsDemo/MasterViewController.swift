//
//  MasterViewController.swift
//  RxSwiftForms
//
//  Created by Michael Long on 2/2/18.
//  Copyright © 2018 Hoy Long. All rights reserved.
//

import UIKit
import RxSwift

class MasterViewController: UITableViewController {

    var disposeBag = DisposeBag()

    var samples = [
        ["title":"Contacts - Material", "segue":"showMaterialForm", "desc":"Material fields and VM unpacks Contact using Mirror."],
        ["title":"Contacts - Show/Hide", "segue":"showContactForm", "desc":"Custom binding and showing/hiding fields."],
        ["title":"Contacts - Reactive", "segue":"showReactiveContactForm", "desc":"Auto binding with a pure Reactive VM."],
        ["title":"Credit Card Form", "segue":"showCreditCard", "desc":"Unpacks dictionary with string-based keys"],
        ["title":"Login Form - Material", "segue":"showLogin", "desc":"Material fields and auto validation on change."],
        ["title":"Validation Tests", "segue":"showValidation", "desc":"Validation testing and building fields on demand."]
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.destination.handleDismissible(MaterialFormViewController.self, setup: { (vc) in
            vc.contact = Contact.testContact1()
        }, completion: { (vc, message: String?) in
            vc.dismiss(animated: true, completion: {
                self.showAlert(message)
            })
        } ) { return }

        if segue.destination.handleDismissible(ContactFormViewController.self, setup: { (vc) in
            vc.contact = Contact.testContact1()
        }, completion: { (vc, message: String?) in
            vc.dismiss(animated: true, completion: {
                self.showAlert(message)
            })
        }) { return }

        if segue.destination.handleDismissible(setup: { (vc: ContactFormReactiveViewController) in
            vc.contact = Contact.testContact1()
        }, completion: { (vc, message: String?) in
            vc.dismiss(animated: true, completion: {
                self.showAlert(message)
            })
        }) { return }

        if segue.destination.handleDismissible(completion: { (vc: CreditCardViewController, results: (String, [String:String])?) in
            vc.dismiss(animated: true, completion: nil)
            if let results = results {
                self.showAlert(results.0)
                print(results.1)
            }
        }) { return }

        if segue.destination.handleDismissible(completion: { (vc: ValidationViewController, message: String?) in
            vc.dismiss(animated: true, completion: {
                self.showAlert(message)
            })
        }) { return }

    }

    func prepareIdentifierSample(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier ?? "" {

        case "showMaterialForm":
            segue.destination.handleDismissible(setup: { (vc: MaterialFormViewController) in
                vc.contact = Contact.testContact1()
            }, completion: { (vc, message: String?) in
                vc.dismiss(animated: true, completion: {
                    self.showAlert(message)
                })
            })

        case "showContactForm":
            segue.destination.handleDismissible { (vc: ContactFormViewController, message: String?) in
                vc.dismiss(animated: true, completion: {
                    self.showAlert(message)
                })
            }

        case "showReactiveContactForm":
            segue.destination.handleDismissible { (vc: ContactFormReactiveViewController, message: String?) in
                vc.dismiss(animated: true, completion: {
                    self.showAlert(message)
                })
            }

        case "showCreditCard":
            segue.destination.handleDismissible { (vc: CreditCardViewController, results: (String, [String:String])?) in
                vc.dismiss(animated: true, completion: nil)
                if let results = results {
                    self.showAlert(results.0)
                    print(results.1)
                }
            }

        case "showValidation":
            segue.destination.handleDismissible { (vc: ValidationViewController, message: String?) in
                vc.dismiss(animated: true, completion: {
                    self.showAlert(message)
                })
            }

        default:
            break
        }

    }

    func showAlert(_ message: String?) {
        guard let message = message else { return }
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return samples.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let sample = samples[indexPath.row]
        cell.textLabel!.text = sample["title"]
        if let desc = sample["desc"] {
            cell.detailTextLabel!.text = desc
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        #if DEBUG
        FxResourceTracking.status()
        #endif
        OperationQueue.main.addOperation {
            let sample = self.samples[indexPath.row]
            self.performSegue(withIdentifier: sample["segue"]!, sender: self)
        }
    }

}

