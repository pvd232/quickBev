//
//  TabCreationViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 12/17/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class TabCreationViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var businessTextField: UITextField!
    @IBOutlet var dateAndTimeTextField: UITextField!
    @IBOutlet var fundraisingGoalTextField: UITextField!
    @IBOutlet var minimumContributionTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextView!
    @IBOutlet var createYourTabStackView: UIStackView!

    var tab: Tab?
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Charter-Roman", size: 20)!]
        navigationController!.navigationBar.standardAppearance.titleTextAttributes = attributes
        businessTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(launchBusinessArrayViewController)))

        descriptionTextField.addLeftBorder(with: UIColor(red: 204.0 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0), andWidth: 1.0)
        descriptionTextField.addRightBorder(with: UIColor(red: 204.0 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0), andWidth: 1.0)
        descriptionTextField.addTopBorder(with: UIColor(red: 204.0 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0), andWidth: 1.0)
        descriptionTextField.addBottomBorder(with: UIColor(red: 204.0 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0), andWidth: 1.0)

        fundraisingGoalTextField.delegate = self
        minimumContributionTextField.delegate = self
        descriptionTextField.delegate = self
        dateAndTimeTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
    }

    @IBAction func nextButtonTapped(_: Any) {
        let nextViewController =
            storyboard?.instantiateViewController(identifier: "TabCreationViewController2") as! TabCreationViewController2
        navigationController?.pushViewController(nextViewController, animated: true)
    }

    @objc func submitTab(_: RoundButton) {
        if nameTextField.text! == "" || businessTextField.text! == "" || dateAndTimeTextField.text! == "" || fundraisingGoalTextField.text! == "" || fundraisingGoalTextField.text! == "" || minimumContributionTextField.text! == "" || descriptionTextField.text! == "" {
            alertError()
        } else {
            tab!.name = nameTextField.text!
            tab!.userId = CheckoutCart.shared.user!.email
            tab!.fundraisingGoal = Int64(fundraisingGoalTextField.text!)!
            tab!.minimumContribution = Int64(minimumContributionTextField.text!)!
            tab!.detail = descriptionTextField.text!

            APIClient().perform(try! APIRequest(method: .post, path: "tabs", body: tab)) {
                result in
                switch result {
                case let .success(value):
                    print("value", value)
                    self.navigationController!.popViewController(animated: true)
                case let .failure(error):
                    print("error", error)
                    return
                }
            }
        }
    }

    override func viewWillAppear(_: Bool) {
        navigationController?.navigationBar.isHidden = false
        createYourTabStackView.isHidden = false
    }

    @objc func launchBusinessArrayViewController() {
        if let viewController = storyboard?.instantiateViewController(identifier: "BusinessArrayViewController") as? BusinessArrayViewController {
            viewController.businessPickerDelegate = self
            let transition = CATransition()
            transition.duration = 0.65
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            navigationController!.view.layer.add(transition, forKey: kCATransition)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    @objc func tapDone() {
        if let datePicker = dateAndTimeTextField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            tab!.dateTime = datePicker.date
            dateAndTimeTextField.text = dateformatter.string(from: datePicker.date) // 2-4
        }
        dateAndTimeTextField.resignFirstResponder() // 2-5
    }

    override func viewWillDisappear(_: Bool) {
        createYourTabStackView.isHidden = true
    }

    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        return string == "" || Int(string) != nil
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}

extension TabCreationViewController {
    private func alertError() {
        return alert(
            title: "Missing Tab Information",
            message: "You need to fill out all the information to create your tab"
        )
    }

    private func alert(title: String, message: String) {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: "Okay", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        })
        present(alertCtrl, animated: true, completion: nil)
    }
}

extension TabCreationViewController: BusinessPickerProtocol {
    func selectedBusinessHandler(_ selectedBusiness: Business) {
        tab!.businessId = selectedBusiness.id
        tab!.address = selectedBusiness.address
        businessTextField.text! = selectedBusiness.name!
    }
}
