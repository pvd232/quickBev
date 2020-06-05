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
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func submitRegistration(_ sender: RoundButton) {
        let encoder = JSONEncoder()
        let newUser = User(email : emailTextField.text!, first_name: firstNameTextField.text!,last_name: lastNameTextField.text!,password: passwordTextField.text! )
        
        // preemtively set the registeredAdministrator to be the requested administrator. if this administrator already exists then it will be changed back to void
        let encodedRegistration = try! encoder.encode(newUser)
        let registrationDictonary = try! JSONSerialization.jsonObject(with:encodedRegistration, options: []) as! [String:NSDictionary]
        submitRequest(parameters: registrationDictonary, requestedNewUser: newUser)
    }
    
    private func submitRequest(parameters: Parameters, requestedNewUser: User)  {
        AF.request("http://127.0.0.1:5000/registerNewUser", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    myUser = requestedNewUser
                    print("sucessfully created new user")
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
                    
                    let navigationController = self.navigationController!
                    navigationController.setViewControllers([nextViewController], animated: true)
                    
                case .failure(let error):
                    // if the request failed, changed the registeredUser back to void
                    print("error", error)
                    myUser = nil
                    
                }
        }
    }
}
