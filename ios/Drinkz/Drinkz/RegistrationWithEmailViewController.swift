//
//  RegistrationWithEmailViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/4/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import Alamofire

class RegistrationWithEmailViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Charter-Roman", size: 25)!]
        self.navigationController!.navigationBar.standardAppearance.titleTextAttributes  = attributes
    }
    
    @IBAction func submitRegistration(_ sender: RoundButton) {
        let encoder = JSONEncoder()
        // this is the guest checkout pathway
        var newUser: User?
        if CheckoutCart.shared.stripeId == nil {
            newUser = User(Email : emailTextField.text!, FirstName: firstNameTextField.text!,LastName: lastNameTextField.text!,Password: passwordTextField.text!)
        }
        else {
            newUser = User(Email : emailTextField.text!, FirstName: firstNameTextField.text!,LastName: lastNameTextField.text!,Password: passwordTextField.text!, StripeId: CheckoutCart.shared.stripeId!)
        }
        
        let encodedRegistration = try! encoder.encode(newUser)
        let registrationDictonary = try! JSONSerialization.jsonObject(with:encodedRegistration, options: []) as! Parameters
        submitRequest(parameters: registrationDictonary, requestedNewUser: newUser!)
    }
    
    private func submitRequest(parameters: Parameters, requestedNewUser: User)  {
        AF.request("http://127.0.0.1:5000/registerNewUser", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    // if the user is a guest then they will have placed an order for a drink already before being redirected to create their account, thus the global variable userOrder will not be nil and the user will be redirected to complete their order
                    
                    CheckoutCart.shared.user = requestedNewUser
                    CheckoutCart.shared.userId = CheckoutCart.shared.user!.email
                    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
                    if requestedNewUser.stripeId == "" {
                        // if the new user's stripe id is nill then this is the regular user creation process and a stripe id will be sent from the backend
                        let json = try? JSONSerialization.jsonObject(with: response.data!, options: []) as? NSDictionary
                        let registeredNewUserStripeId = json!["stripe_id"] as! String
                        CheckoutCart.shared.stripeId = registeredNewUserStripeId
                        requestedNewUser.stripeId = registeredNewUserStripeId
                        self.alertAccountCreation()
                    }
                    // the user is creating an account without having ordered something prior as a guest. this is the typical process which redirects to the home page
                    else {
                        self.alertAccountCreationForGuest()
                    }
                    CoreDataManager.sharedManager.saveContext(context: managedContext)
                    
                case .failure(let error):
                    // if the request failed, changed the registeredUser back to void
                    print("error", error)
                    CheckoutCart.shared.user = nil
                    
                }
            }
    }
    private func alertAccountCreationForGuest() {
        return self.alert(
            title: "",
            message: "Welcome to QuickBev! You may now proceed with your order.",
            alertType: "accountCreationGuest"
        )
    }
    private func alertAccountCreation() {
        return self.alert(
            title: "",
            message: "Welcome to QuickBev!",
            alertType: "accountCreation"
        )
    }
    private func alert(title: String, message: String, alertType: String) {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if alertType == "accountCreationGuest"{
            alertCtrl.addAction(UIAlertAction(title: "Okay", style: .cancel) { action in
                let drinkViewController =  self.storyboard!.instantiateViewController(identifier: "DrinkViewController") as! DrinkViewController
                let homePageViewController =  self.storyboard!.instantiateViewController(identifier: "HomePageViewController") as! HomePageViewController
                let drinkListTableViewController =  self.storyboard!.instantiateViewController(identifier: "DrinkListTableViewController") as! DrinkListTableViewController
                let navigationController = self.navigationController!
                navigationController.setViewControllers([drinkViewController, drinkListTableViewController, homePageViewController], animated: true)
            })
        }
        else if alertType == "accountCreation" {
            alertCtrl.addAction(UIAlertAction(title: "Okay", style: .cancel) { action in
                SceneDelegate.shared.rootViewController.switchToHomePage()
//            navigationController.setViewControllers([HomePageViewController()], animated: true)
            })
        }
        present(alertCtrl, animated: true, completion: nil)
    }
}
