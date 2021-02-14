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

class LoginViewController: UIViewController,  UITextFieldDelegate {
    @UsesAutoLayout var signInButtonsStackView = UIStackView()
    @UsesAutoLayout var letsGetStartedStackView = UIStackView()
    @UsesAutoLayout var letsGetStartedLabel : UILabel
        = {
           let label = UILabel(theme:Theme.UILabel(props: [.textColor]))
            label.font = UIFont.largeThemeLabelFont
            return label
        }()
    @UsesAutoLayout var ellipsisLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    // this label is in all caps so it needs to be smaller
    @UsesAutoLayout var signInToQuickBevLabel: UILabel  = {
        if UIViewController.screenSize.height <= 736 {
            let smallFontUILabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
            smallFontUILabel.font =  UIFont(name: "Charter-Roman", size: 20.0)
            return smallFontUILabel
        }
        else {
            let largeFontUILabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
            largeFontUILabel.font = UIFont(name: "Charter-Roman", size: 22.0)
            return largeFontUILabel
        }
    }()
    @UsesAutoLayout var logoImageView = UIImageView()
    @UsesAutoLayout var emailAddressLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var emailTextField = UITextField()
    @UsesAutoLayout var passwordLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var passwordTextField = UITextField()
    @UsesAutoLayout var forgotPasswordButton = UIButton()
    @UsesAutoLayout var submitButton = RoundButton()
    @UsesAutoLayout private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    let logoImage = UIImage(named:"charterRomanPurpleLogo-30")
    
    var formValue: [String:String] = [:]
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
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
        letsGetStartedLabel.textColor = .black
        
        ellipsisLabel.text = "· · ·"
        ellipsisLabel.font = UIFont(name: "System-Bold", size: 20.0)
        ellipsisLabel.textAlignment = .center
        ellipsisLabel.textColor = .black
        
        signInToQuickBevLabel.text = "SIGN IN TO QUICKBEV"
        signInToQuickBevLabel.textAlignment = .center
        signInToQuickBevLabel.textColor = .black
        
        emailAddressLabel.text = "Email Address"
        emailAddressLabel.font = UIFont.themeLabelFont
        emailAddressLabel.textColor = .black
        
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        emailTextField.backgroundColor = UIColor.clear
        // in order to identify the textfield when extracting information for form value
        emailTextField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.clear])
        emailTextField.addLeftBorder(with: UIColor.init(red: 204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0), andWidth: 1.0)
        emailTextField.addRightBorder(with: UIColor.init(red: 204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0), andWidth: 1.0)
        emailTextField.addTopBorder(with: UIColor.init(red: 204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0), andWidth: 1.0)
        emailTextField.addBottomBorder(with: UIColor.init(red: 204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0), andWidth: 1.0)
        
        passwordLabel.text = "Password"
        passwordLabel.textColor = .black
        passwordLabel.font = UIFont.themeLabelFont
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.autocapitalizationType = .none
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.isSecureTextEntry = true
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.clear])
        passwordTextField.addLeftBorder(with: UIColor.init(red: 204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0), andWidth: 1.0)
        passwordTextField.addRightBorder(with: UIColor.init(red: 204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0), andWidth: 1.0)
        passwordTextField.addTopBorder(with: UIColor.init(red: 204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0), andWidth: 1.0)
        passwordTextField.addBottomBorder(with: UIColor.init(red: 204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0), andWidth: 1.0)
        
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
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        let safeArea = self.view.safeAreaLayoutGuide
        

        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: CGFloat(0.565217)),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            logoImageView.bottomAnchor.constraint(lessThanOrEqualTo :letsGetStartedStackView.topAnchor , constant: -10.0),
            logoImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: (0.02 * UIViewController.screenSize.height)),
            
            letsGetStartedStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            letsGetStartedStackView.bottomAnchor.constraint(lessThanOrEqualTo: signInButtonsStackView.topAnchor, constant: (-(0.095 * UIViewController.screenSize.height))),
            letsGetStartedStackView.heightAnchor.constraint(greaterThanOrEqualTo: safeArea.heightAnchor, multiplier: 0.12),
            
            signInButtonsStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            signInButtonsStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
            signInButtonsStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
            signInButtonsStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10.0),
            signInButtonsStackView.heightAnchor.constraint(greaterThanOrEqualTo: safeArea.heightAnchor, multiplier: 0.28),
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("text field editing")
        if textField.placeholder == "email" {
            formValue["email"] = textField.text!
        }
        else if textField.placeholder == "password" {
            formValue["password"] = textField.text!
        }
            return true

    }
    func textFieldDidEndEditing(_ textField: UITextField){
        print("did end")
        if textField.placeholder == "email" {
            formValue["email"] = textField.text!
        }
        else if textField.placeholder == "password" {
            formValue["password"] = textField.text!
        }
    }
    
    @objc private func submitButtonPressed(_ sender: RoundButton) {
        activityIndicator.startAnimating()
        
        let userCredentials: [HTTPHeader] = [HTTPHeader(field: "email", value:emailTextField.text! ), HTTPHeader(field:"password", value:passwordTextField.text! )]
        let request = APIRequest(method: .get, path:"/login")
        request.headers = userCredentials
        print("email", formValue["email"])
        print("password", formValue["password"])

        APIClient().perform(request) { result in // this bracket is the trailing closure that is being passed into the APIClient perform function as an argument for the completion parameter. the data is the parameter that was passed into the completion by the APIClient perform function, which was in turn returned the data by the URL session task
            switch result {
            case .success (let response): // the response is the APIResponse struct parameter that was passed into the APIResult instance for the .success case
                if response.statusCode == 200, let response = try? response.decode(to: User.self)  {
                    var user = response.body
                    print("self.formValue[email]", self.formValue["email"])
                    print("self.formValue[password]", self.formValue["password"])

                    user.email = self.formValue["email"]
                    user.password = self.formValue["password"]
//                    user.email = emailTextField.text
                    if let fetchedUsers = CoreDataManager.sharedManager.fetchEntities(entityName: "User") as? [User] {
                        for fetchedUser in fetchedUsers{
                            if fetchedUser.id == user.id{
                                user = fetchedUser
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        CheckoutCart.shared.user = user
                        CheckoutCart.shared.userId = user.email
                        CheckoutCart.shared.stripeId = user.stripeId
                        CoreDataManager.sharedManager.saveContext()
                        SceneDelegate.shared.rootViewController.switchToHomePageViewController()
                        self.activityIndicator.stopAnimating()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        
                        let alertController = UIAlertController(title: "Incorrect Username", message: "Your username or password was incorrect. Please try again.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Try again", style: .cancel) { action in
                            self.dismiss( animated: true)
                        })
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                }
            case .failure(let error):                    // if the API fails the enum API result will be of the type failure
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    
                    let alertController = UIAlertController(title: "Network Error", message: "A network error has occured. Check your internet connection and if necessary, restart the app.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Okay", style: .cancel) { action in
                        self.dismiss( animated: true)
                    })
                    self.present(alertController, animated: true, completion: nil)
                    print("error case .failure", error)
                    
                }
            }
        }
    }
    override func viewDidLayoutSubviews() {
        print("height", letsGetStartedStackView.frame.size.height)
    }
}



