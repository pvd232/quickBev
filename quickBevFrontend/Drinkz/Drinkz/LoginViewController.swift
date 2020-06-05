//
//  LoginViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/1/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import Alamofire
var myUser : User?

class LoginViewController: UIViewController {
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonPressed(_ sender: RoundButton) {
        let userCredentials: HTTPHeaders = ["email": emailTextField.text!, "password" : passwordTextField.text!]
        validateUser (headers: userCredentials) { data in
            
            // the entered credentials do not match an existing administrator nor user thus the login failed and a nil value was returned
            guard data != nil else {
                
                myUser = nil
                
                // TODO: Make a pretty little error message that appears if your login was incorrect - base it off of Instagram or FB maybe?
                print("data returned from submit button is nill")
                return
            }
            guard myUser != nil else {
                print("user value is nil")
                return
            }
            //https://stackoverflow.com/questions/33374272/swift-ios-set-a-new-root-view-controller
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
            
            let navigationController = self.navigationController!
            navigationController.setViewControllers([nextViewController], animated: true)
        }
    }
    
    private func validateUser(headers: HTTPHeaders, completion: @escaping (User?) -> Void) {
        AF.request("http://127.0.0.1:5000/login", method: .get, headers : headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    
                    guard let returnedUser = response.data
                        
                        else {
                            print("error user not returned")
                            return completion(nil)
                    }
                    
                    let jsonDecoder = JSONDecoder()
                    
                    let formattedUser = try! jsonDecoder.decode(User.self, from: returnedUser)
                    myUser = formattedUser
                    
                case .failure(let error):
                    completion(nil)
                    print("error case .failure", error)
                }
                completion(myUser)
        }
    }
}


