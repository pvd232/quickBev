//
//  TabCreationViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 12/17/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import Alamofire

class TabCreationViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var businessTextField: UITextField!
    @IBOutlet weak var dateAndTimeTextField: UITextField!
    @IBOutlet weak var fundraisingGoalTextField: UITextField!
    @IBOutlet weak var minimumContributionTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var createYourTabStackView: UIStackView!
    
    
    var tab: Tab?
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Charter-Roman", size: 20)!]
        self.navigationController!.navigationBar.standardAppearance.titleTextAttributes  = attributes
        businessTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(launchBusinessArrayViewController)))
        
        descriptionTextField.addLeftBorder(with: UIColor.init(red: 204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0), andWidth: 1.0)
        descriptionTextField.addRightBorder(with: UIColor.init(red: 204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0), andWidth: 1.0)
        descriptionTextField.addTopBorder(with: UIColor.init(red: 204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0), andWidth: 1.0)
        descriptionTextField.addBottomBorder(with: UIColor.init(red: 204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0), andWidth: 1.0)
        
        fundraisingGoalTextField.delegate = self
        minimumContributionTextField.delegate = self
        descriptionTextField.delegate = self
        dateAndTimeTextField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let nextViewController =
            storyboard?.instantiateViewController(identifier: "TabCreationViewController2") as! TabCreationViewController2
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func submitTab(_ sender: RoundButton) {
        if nameTextField.text! == "" || businessTextField.text! == "" || dateAndTimeTextField.text! == "" || fundraisingGoalTextField.text! == "" || fundraisingGoalTextField.text! == "" || minimumContributionTextField.text! == "" || descriptionTextField.text! == ""  {
            self.alertError()
        }
        else {
            tab!.name = nameTextField.text!
            tab!.userId = CheckoutCart.shared.user!.email
            tab!.fundraisingGoal = Int64(fundraisingGoalTextField.text!)!
            tab!.minimumContribution = Int64(minimumContributionTextField.text!)!
            tab!.detail = descriptionTextField.text!
            
            let encoder = JSONEncoder()
            let encodedTab = try! encoder.encode(tab)
            let tabJSON = try! JSONSerialization.jsonObject(with:encodedTab, options: []) as! Parameters
            
            AF.request("http://127.0.0.1:5000/tabs", method: .post, parameters: tabJSON, encoding: JSONEncoding.default)
                .validate()
                .responseJSON { response in
                    debugPrint("response", response)
                    switch response.result {
                    case .success (let value):
                        print("value", value)
                        self.navigationController!.popViewController(animated: true)
                    case .failure (let error):
                        print("error", error)
                        return
                        
                    }
                }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.createYourTabStackView.isHidden = false
    }
    @objc func launchBusinessArrayViewController () {
        if let viewController = storyboard?.instantiateViewController(identifier: "BusinessArrayViewController") as? BusinessArrayViewController {
            viewController.businessPickerDelegate = self
            let transition:CATransition = CATransition()
            transition.duration = 0.65
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            navigationController!.view.layer.add(transition, forKey: kCATransition)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func tapDone() {
        if let datePicker = self.dateAndTimeTextField.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            tab!.dateTime = datePicker.date
            self.dateAndTimeTextField.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.dateAndTimeTextField.resignFirstResponder() // 2-5
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.createYourTabStackView.isHidden = true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string == "" || Int(string) != nil
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
}
extension UIView {
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
    
    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
    
    func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        addSubview(border)
    }
    
    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        addSubview(border)
    }
}
extension TabCreationViewController {
    private func alertError() {
        return self.alert(
            title: "Missing Tab Information",
            message: "You need to fill out all the information to create your tab"
        )
    }
    private func alert(title: String, message: String) {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: "Okay", style: .cancel) { action in
            self.dismiss(animated: true, completion: nil)
        })
        present(alertCtrl, animated: true, completion: nil)
    }
}
extension TabCreationViewController:BusinessPickerProtocol {
    func selectedBusinessHandler(_ selectedBusiness: Business) {
        tab!.businessId = selectedBusiness.id
        tab!.address = selectedBusiness.address
        self.businessTextField.text! = selectedBusiness.name!
    }
}
