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
    @UsesAutoLayout var letsGetStartedLabel : UILabel
        = {
            if UIViewController.screenSize.height <= 667 {
                let smallFontUILabel = UILabel()
                smallFontUILabel.font =  UIFont(name: "Charter-Roman", size: 24.0)
                return smallFontUILabel
            }
            else {
                let largeFontUILabel = UILabel()
                largeFontUILabel.font = UIFont(name: "Charter-Roman", size: 30.0)
                return largeFontUILabel
            }
        }()
    @UsesAutoLayout var ellipsisLabel = UILabel()
    @UsesAutoLayout var signInToQuickBevLabel: UILabel  = {
        if UIViewController.screenSize.height <= 667 {
            let smallFontUILabel = UILabel()
            smallFontUILabel.font =  UIFont(name: "Charter-Roman", size: 18.0)
            return smallFontUILabel
        }
        else {
            let largeFontUILabel = UILabel()
            largeFontUILabel.font = UIFont(name: "Charter-Roman", size: 24.0)
            return largeFontUILabel
        }
    }()
    @UsesAutoLayout var logoImageView = UIImageView()
    @UsesAutoLayout var emailAddressLabel = UILabel()
    @UsesAutoLayout var emailTextField = UITextField()
    @UsesAutoLayout var passwordLabel = UILabel()
    @UsesAutoLayout var passwordTextField = UITextField()
    @UsesAutoLayout var forgotPasswordButton = UIButton()
    @UsesAutoLayout var submitButton = RoundButton()
    
    @UsesAutoLayout private var activityIndicator = UIActivityIndicatorView(style: .large)
    lazy var logoMultiplier: Float = { if UIViewController.screenSize.height <= 700 {
        return 0.565217
    }
    else {
        return 0.65
    }
    }()
    
    lazy var centerLabelBool: Bool = { if UIViewController.screenSize.height <= 700 {
        return false
    }
    else {
        return true
    }
    }()
    
    let logoImage = UIImage(named:"charterRomanPurpleLogo-30")
    
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
        
        letsGetStartedLabel.text = "Let's Get Started"
        letsGetStartedLabel.textAlignment = .center
        
        ellipsisLabel.text = "· · ·"
        ellipsisLabel.font = UIFont(name: "System-Bold", size: 20.0)
        ellipsisLabel.textAlignment = .center
        
        signInToQuickBevLabel.text = "SIGN IN TO QUICKBEV"
        signInToQuickBevLabel.textAlignment = .center
        
        emailAddressLabel.text = "Email Address"
        emailAddressLabel.font = UIFont.themeLabelFont
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        emailTextField.backgroundColor = UIColor.clear
        
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont.themeLabelFont
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.autocapitalizationType = .none
        passwordTextField.backgroundColor = UIColor.clear
        
        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgotPasswordButton.titleLabel?.font = UIFont(name: "Charter-Roman", size: 18.0)
        forgotPasswordButton.setTitleColor(.black, for: .normal)
        forgotPasswordButton.contentHorizontalAlignment = .center
        
        logoImageView.image = logoImage
        
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
        
        self.view.addSubview(logoImageView)
        self.view.addSubview(letsGetStartedStackView)
        self.view.addSubview(signInButtonsStackView)
        self.view.bringSubviewToFront(activityIndicator
        )
        let safeArea = self.view.safeAreaLayoutGuide
        
        if centerLabelBool {
            letsGetStartedStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        }
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: CGFloat(logoMultiplier)),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            logoImageView.bottomAnchor.constraint(lessThanOrEqualTo :letsGetStartedStackView.topAnchor , constant: -10.0),
            logoImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: (0.025 * UIViewController.screenSize.height)),
            
            letsGetStartedStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            letsGetStartedStackView.bottomAnchor.constraint(lessThanOrEqualTo: signInButtonsStackView.topAnchor, constant: (-(0.06 * UIViewController.screenSize.height))),
            letsGetStartedStackView.heightAnchor.constraint(greaterThanOrEqualTo: safeArea.heightAnchor, multiplier: 0.12),
            
            signInButtonsStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            signInButtonsStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
            signInButtonsStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
            signInButtonsStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20.0),
            signInButtonsStackView.heightAnchor.constraint(greaterThanOrEqualTo: safeArea.heightAnchor, multiplier: 0.25),
            signInButtonsStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            forgotPasswordButton.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.07),
            emailTextField.widthAnchor.constraint(equalTo: emailTextField.heightAnchor, multiplier: (197/25)),
            passwordTextField.widthAnchor.constraint(equalTo: passwordTextField.heightAnchor, multiplier: (197/25)),
            submitButton.widthAnchor.constraint(equalTo: submitButton.heightAnchor, multiplier: (197/25)),
            
            activityIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
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
            SceneDelegate.shared.rootViewController.switchToHomePageViewController()
            
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
                    // need to create an optional user that will either be assigned to the novel user returned from login or from the existing user in core data if the user logged out so we don't create a duplicate instances of the same user
                    var user: User?
                    guard let returnedUser = response.data
                    
                    else {
                        print("error user not returned")
                        completion(nil)
                        return
                    }
                    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
                    let jsonDecoder = JSONDecoder()
                    user = try! jsonDecoder.decode(User.self, from: returnedUser)
                    
                    if let fetchedUsers = CoreDataManager.sharedManager.fetchEntities(entityName: "User", context: managedContext) as? [User] {
                        for fetchedUser in fetchedUsers{
                            if fetchedUser.id == user!.id{
                                user = fetchedUser
                            }
                        }
                    }
                    CheckoutCart.shared.user = user
                    CheckoutCart.shared.userId = user!.email
                    CheckoutCart.shared.stripeId = user!.stripeId
                    CoreDataManager.sharedManager.saveContext(context: managedContext)
                    // if the API is successful the user that is returned is passed into the completion as a parameter
                    completion(user)
                case .failure(let error):                    // if the API fails nil is passed into the completion as a parameter
                    completion(nil)
                    print("error case .failure", error)
                }
            }
    }
    override func viewDidLayoutSubviews() {
        print("height", letsGetStartedStackView.frame.size.height)
    }
}


