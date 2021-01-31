//
//  LoginViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/1/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import Alamofire
import Stripe
import CoreData

class LoginViewController: UIViewController {
    @UsesAutoLayout var signInButtonsStackView = UIStackView()
    @UsesAutoLayout var letsGetStartedStackView = UIStackView()
    @UsesAutoLayout var letsGetStartedLabel = UILabel()
    @UsesAutoLayout var ellipsisLabel = UILabel()
    @UsesAutoLayout var signInToQuickBevLabel = UILabel()
    @UsesAutoLayout var moonImageView = UIImageView()
    let moonImage = UIImage(named:"moon")
    @UsesAutoLayout var emailAddressLabel = UILabel()
    @UsesAutoLayout var emailTextField = UITextField()
    @UsesAutoLayout var passwordLabel = UILabel()
    @UsesAutoLayout var passwordTextField = UITextField()
    @UsesAutoLayout var forgotPasswordButton = UIButton()
    @UsesAutoLayout var submitButton = RoundButton()
    
    @UsesAutoLayout private var activityIndicator = UIActivityIndicatorView(style: .large)

    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder not set up")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        navigationController?.view.backgroundColor = navigationController?.navigationBar.barTintColor
        
        letsGetStartedLabel.text = "Let's Get Started"
        letsGetStartedLabel.font = UIFont(name: "Charter-Roman", size: 32.0)
        letsGetStartedLabel.textAlignment = .center

        
        ellipsisLabel.text = "· · ·"
        ellipsisLabel.font = UIFont(name: "System-Bold", size: 20.0)
        ellipsisLabel.textAlignment = .center
        
        signInToQuickBevLabel.text = "SIGN IN TO QUICKBEV"
        signInToQuickBevLabel.font = UIFont(name: "Charter-Roman", size: 20.0)
        signInToQuickBevLabel.textAlignment = .center

        
        emailAddressLabel.text = "Email Address"
        emailAddressLabel.font = UIFont(name: "Charter-Roman", size: 20.0)
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        emailTextField.backgroundColor = UIColor.clear

        
        
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont(name: "Charter-Roman", size: 20.0)
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.autocapitalizationType = .none
        passwordTextField.backgroundColor = UIColor.clear

        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgotPasswordButton.titleLabel?.font = UIFont(name: "Charter-Roman", size: 18.0)
        forgotPasswordButton.setTitleColor(.black, for: .normal)
        forgotPasswordButton.contentHorizontalAlignment = .center
        forgotPasswordButton.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        forgotPasswordButton.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        
        moonImageView.image = moonImage
        
        letsGetStartedStackView.axis = .vertical
        letsGetStartedStackView.addArrangedSubview(letsGetStartedLabel)
        letsGetStartedStackView.addArrangedSubview(ellipsisLabel)
        letsGetStartedStackView.addArrangedSubview(signInToQuickBevLabel)
        letsGetStartedStackView.spacing = 3.0
        
        signInButtonsStackView.axis = .vertical
        signInButtonsStackView.addArrangedSubview(emailAddressLabel)
        signInButtonsStackView.addArrangedSubview(emailTextField)
        signInButtonsStackView.addArrangedSubview(passwordLabel)
        signInButtonsStackView.addArrangedSubview(passwordTextField)
        signInButtonsStackView.addArrangedSubview(forgotPasswordButton)
        signInButtonsStackView.addArrangedSubview(submitButton)
        signInButtonsStackView.spacing = 2.0
        
        submitButton.refreshTitle(newTitle: "Submit")
        submitButton.titleLabel?.textColor = UIColor.white
        submitButton.titleLabel?.font = UIFont(name: "Charter-Black", size: 20.0)
        submitButton.refreshColor(color:  UIColor.init(red: 134/255, green: 130/255, blue: 230/255, alpha: 1.0))
        
        self.view.addSubview(moonImageView)
        self.view.addSubview(letsGetStartedStackView)
        self.view.addSubview(signInButtonsStackView)
        self.view.bringSubviewToFront(activityIndicator
        )
        let margins = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
        moonImageView.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.565217),
        moonImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10.0),
            moonImageView.heightAnchor.constraint(equalTo: moonImageView.widthAnchor),
        moonImageView.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            moonImageView.bottomAnchor.constraint(equalTo:letsGetStartedStackView.topAnchor , constant: -10.0),
            moonImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40.0).usingPriority(UILayoutPriority(750)),
            
            letsGetStartedStackView.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            letsGetStartedStackView.topAnchor.constraint(equalTo: moonImageView.bottomAnchor, constant: 20.0).usingPriority(UILayoutPriority(750)),

            signInButtonsStackView.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            signInButtonsStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10.0),
            signInButtonsStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10.0),
            signInButtonsStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -10.0).usingPriority(UILayoutPriority(750)),
            signInButtonsStackView.topAnchor.constraint(equalTo: letsGetStartedStackView.bottomAnchor, constant: 128.0).usingPriority(UILayoutPriority(250)),
            signInButtonsStackView.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: emailTextField.heightAnchor, multiplier: (197/25)),
            passwordTextField.widthAnchor.constraint(equalTo: passwordTextField.heightAnchor, multiplier: (197/25)),
            submitButton.widthAnchor.constraint(equalTo: submitButton.heightAnchor, multiplier: (197/25)),
            activityIndicator.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: activityIndicator.superview!.widthAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.superview!.heightAnchor)
        ])
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
    }
    
    @objc private func submitButtonPressed(_ sender: RoundButton) {
        activityIndicator.startAnimating()

        let userCredentials: HTTPHeaders = ["email": emailTextField.text!, "password" : passwordTextField.text!]
        validateUser (headers: userCredentials) { // this bracket is the trailing closure that is being passed into the validate user function as an argument for the completion parameter. the data is the parameter that was passed into the completion by the validate user function
            
            data in
            guard data != nil else {
                CheckoutCart.shared.user = nil
                // TODO: Make a pretty little error message that appears if your login was incorrect - base it off of Instagram or FB maybe?
                self.activityIndicator.stopAnimating()

                print("data returned from submit button is nill")
                return
            }
            guard CheckoutCart.shared.user != nil else {
                print("user value is nil")
                return
            }
//            let nextViewController =  HomePageViewController()
//            self.navigationController!.setViewControllers([nextViewController], animated: true)
            SceneDelegate.shared.rootViewController.switchToHomePage()

            self.activityIndicator.stopAnimating()
        }
    }
    // the completion parameter takes in a closure that takes in an optional User and returns nothing.
    private func validateUser(headers: HTTPHeaders, completion: @escaping (User?) -> Void) {
        AF.request("http://127.0.0.1:5000/login", method: .get, headers : headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    guard let returnedUser = response.data
                    else {
                        print("error user not returned")
                        completion(nil)
                        return
                    }
                    let jsonDecoder = JSONDecoder()
                    let formattedUser = try! jsonDecoder.decode(User.self, from: returnedUser)
                    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
                    CheckoutCart.shared.user = formattedUser
                    CheckoutCart.shared.userId = formattedUser.email
                    CheckoutCart.shared.stripeId = formattedUser.stripeId
                    CoreDataManager.sharedManager.saveContext(context: managedContext)
                    // if the API is successful the user that is returned is passed into the completion as a parameter
                    completion(CheckoutCart.shared.user)
                case .failure(let error):                    // if the API fails nil is passed into the completion as a parameter
                    completion(nil)
                    print("error case .failure", error)
                }
            }
    }
}


