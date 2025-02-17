//
//  RegistrationWithEmailViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/4/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class RegistrationWithEmailViewController: UIViewController, UITextFieldDelegate {
    @UsesAutoLayout var firstNameTextField = RoundedUITextField(theme: Theme.UITextField(props: [.font(nil), .placeHolderText("Your first name"), .autocapitalizationType(autocapitalizationType: .none), .borderStyle(borderStyle: .roundedRect), .backgroundColor(UIColor.clear)]))
    @UsesAutoLayout var lastNameTextField = RoundedUITextField(theme: Theme.UITextField(props: [.font(nil), .placeHolderText("Your last name"), .autocapitalizationType(autocapitalizationType: .none), .borderStyle(borderStyle: .roundedRect), .backgroundColor(UIColor.clear)]))
    @UsesAutoLayout var emailTextField = RoundedUITextField(theme: Theme.UITextField(props: [.font(nil), .placeHolderText("Your email address"), .autocapitalizationType(autocapitalizationType: .none), .borderStyle(borderStyle: .roundedRect), .backgroundColor(UIColor.clear)]))
    @UsesAutoLayout var confirmEmailTextField = RoundedUITextField(theme: Theme.UITextField(props: [.font(nil), .placeHolderText("Confirm your email address"), .autocapitalizationType(autocapitalizationType: .none), .borderStyle(borderStyle: .roundedRect), .backgroundColor(UIColor.clear)]))
    @UsesAutoLayout var passwordTextField = RoundedUITextField(theme: Theme.UITextField(props: [.font(nil), .placeHolderText("Your password"), .autocapitalizationType(autocapitalizationType: .none), .borderStyle(borderStyle: .roundedRect), .backgroundColor(UIColor.clear)]))
    @UsesAutoLayout var confirmPasswordTextField = RoundedUITextField(theme: Theme.UITextField(props: [.font(nil), .placeHolderText("Confirm your password"), .autocapitalizationType(autocapitalizationType: .none), .borderStyle(borderStyle: .roundedRect), .backgroundColor(UIColor.clear)]))
    @UsesAutoLayout var firstNameLabel = UILabel(theme: Theme.UILabel(props: [.text("First Name"), .font(nil), .textColor]))
    @UsesAutoLayout var lastNameLabel = UILabel(theme: Theme.UILabel(props: [.text("Last Name"), .font(nil), .textColor]))
    @UsesAutoLayout var emailLabel = UILabel(theme: Theme.UILabel(props: [.text("Email"), .font(nil), .textColor]))
    @UsesAutoLayout var passwordLabel = UILabel(theme: Theme.UILabel(props: [.text("Password"), .font(nil), .textColor]))
    @UsesAutoLayout var confirmEmailLabel = UILabel(theme: Theme.UILabel(props: [.text("Confirm Email"), .font(nil), .textColor]))
    @UsesAutoLayout var confirmPasswordLabel = UILabel(theme: Theme.UILabel(props: [.text("Confirm Password"), .font(nil), .textColor]))
    @UsesAutoLayout var registrationStackView = UIStackView(theme: Theme.UIStackView(props: [.vertical, .spacing(10)]))
    @UsesAutoLayout var submitButton = RoundButton(theme: Theme.RoundButton(props: [.color, .text("Submit"), .titleLabelFont(nil)]))
    @UsesAutoLayout private var activityIndicator = UIActivityIndicatorView(style: .large)

    var formValues: [String: String] = [:]
    private lazy var navController: UINavigationController = {
        SceneDelegate.shared.rootViewController.current as! UINavigationController
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("coder not set up")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(registrationStackView)
        view.addSubview(submitButton)
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        registrationStackView.addArrangedSubview(firstNameLabel)
        registrationStackView.addArrangedSubview(firstNameTextField)
        registrationStackView.addArrangedSubview(lastNameLabel)
        registrationStackView.addArrangedSubview(lastNameTextField)
        registrationStackView.addArrangedSubview(emailLabel)
        registrationStackView.addArrangedSubview(emailTextField)
        registrationStackView.addArrangedSubview(confirmEmailLabel)
        registrationStackView.addArrangedSubview(confirmEmailTextField)
        registrationStackView.addArrangedSubview(passwordLabel)
        registrationStackView.addArrangedSubview(passwordTextField)
        registrationStackView.addArrangedSubview(confirmPasswordLabel)
        registrationStackView.addArrangedSubview(confirmPasswordTextField)

        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        confirmEmailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: activityIndicator.superview!.widthAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.superview!.heightAnchor),
            submitButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10.0),
            submitButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
            submitButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
            submitButton.widthAnchor.constraint(equalTo: submitButton.heightAnchor, multiplier: 197 / 25),
            submitButton.topAnchor.constraint(lessThanOrEqualTo: registrationStackView.bottomAnchor, constant: UIViewController.screenSize.height * 0.31),

            firstNameTextField.widthAnchor.constraint(equalTo: firstNameTextField.heightAnchor, multiplier: 197 / 25),
            lastNameTextField.widthAnchor.constraint(equalTo: lastNameTextField.heightAnchor, multiplier: 197 / 25),
            emailTextField.widthAnchor.constraint(equalTo: emailTextField.heightAnchor, multiplier: 197 / 25),
            confirmEmailTextField.widthAnchor.constraint(equalTo: confirmEmailTextField.heightAnchor, multiplier: 197 / 25),
            passwordTextField.widthAnchor.constraint(equalTo: passwordTextField.heightAnchor, multiplier: 197 / 25),
            confirmPasswordTextField.widthAnchor.constraint(equalTo: confirmPasswordTextField.heightAnchor, multiplier: 197 / 25),

            registrationStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
            registrationStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
            registrationStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
        ]
        )
        submitButton.addTarget(self, action: #selector(submitRegistration), for: .touchUpInside)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.placeholder == "Your first name" {
            formValues["firstName"] = textField.text
        }
        if textField.placeholder == "Your last name" {
            formValues["lastName"] = textField.text
        }
        if textField.placeholder == "Your email address" {
            formValues["email"] = textField.text
        }
        if textField.placeholder == "Confirm your email address" {
            formValues["confirmEmail"] = textField.text
        }
        if textField.placeholder == "Your password" {
            formValues["password"] = textField.text
        }
        if textField.placeholder == "Confirm your password" {
            formValues["confirmPassword"] = textField.text
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.placeholder == "Your first name" {
            formValues["firstName"] = textField.text
        }
        if textField.placeholder == "Your last name" {
            formValues["lastName"] = textField.text
        }
        if textField.placeholder == "Your email address" {
            formValues["email"] = textField.text
        }
        if textField.placeholder == "Confirm your email address" {
            formValues["confirmEmail"] = textField.text
        }
        if textField.placeholder == "Your password" {
            formValues["password"] = textField.text
        }
        if textField.placeholder == "Confirm your password" {
            formValues["confirmPassword"] = textField.text
        }
        return true
    }

    @objc private func submitRegistration(_: RoundButton) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }

        let requestedNewUser: User = {
            // regular registration process
            if CheckoutCart.shared.isGuest == false {
                return User(FirstName: firstNameTextField.text!, LastName: lastNameTextField.text!, Email: emailTextField.text!, Password: passwordTextField.text!, EmailVerified: false)
            }
            // guest registration process because the stripe id was acquired at home page when a user did not yet exist
            else {
                return User(FirstName: firstNameTextField.text!, LastName: lastNameTextField.text!, Email: emailTextField.text!, Password: passwordTextField.text!, StripeId: CheckoutCart.shared.stripeId!, EmailVerified: false)
            }
        }()

        if formValues["email"] != formValues["confirmEmail"] || formValues["password"] != formValues["confirmPassword"] {
            var title = ""
            var message = ""

            if formValues["email"] != formValues["confirmEmail"], formValues["password"] == formValues["confirmPassword"] {
                title = "Email mismatch"
                message = "Email and confirmation email are different. Please correct them and resubmit"
            } else if formValues["password"] != formValues["confirmPassword"], formValues["email"] == formValues["confirmEmail"] {
                title = "Password mismatch"
                message = "Password and confirmation password are different. Please correct them and resubmit"
            } else if formValues["email"] != formValues["confirmEmail"], formValues["password"] != formValues["confirmPassword"] {
                title = "Email and password mismatch"
                message = "Email, confirmation email, password and confirmation password are different. Please correct them and resubmit"
            }

            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Try again", style: .cancel) { _ in
                self.dismiss(animated: true)
            })
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            let userCredentials: [HTTPHeader] = [HTTPHeader(field: "DeviceToken", value: CheckoutCart.shared.deviceToken)]
            let request = try! APIRequest(method: .post, path: "/customer", body: requestedNewUser, headers: userCredentials)
            APIClient().perform(request) { result in
                switch result {
                case let .success(response):
                    if response.statusCode == 200, let response = try? response.decode(to: User.self) {
                        let fetchedUser = response.body as User
                        CheckoutCart.shared.user = fetchedUser
                        CheckoutCart.shared.userId = requestedNewUser.email

                        // when changing UI based on asynchronous operation, or when updating core data need to wrap in dispatch queue because both are asynchronous ops themselves
                        if CheckoutCart.shared.isGuest == false {
                            // if the new user's stripe id is nill then this is the regular user creation process and a stripe id will be sent from the backend
                            CheckoutCart.shared.stripeId = fetchedUser.stripeId
                            requestedNewUser.stripeId = fetchedUser.stripeId

                            let sessionToken = response.headers["authorization-token"] as! String
                            try! SecureStore(secureStoreQueryable: GenericPasswordQueryable()).setValue(sessionToken, for: "sessionToken")
                            // set the token in the shopping cart and use it whenever calling the backend
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                                self.alertAccountCreation()
                            }
                        }
                        // the user is creating an account without having ordered something prior as a guest. this is the typical process which redirects to the home page
                        else {
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                                self.alertAccountCreationForGuest()
                                CoreDataManager.sharedManager.saveContext()
                            }
                        }
                    } else if response.statusCode == 201, let response = try? response.decode(to: User.self) {
                        let fetchedUser = response.body as User
                        CheckoutCart.shared.user = fetchedUser
                        CheckoutCart.shared.userId = requestedNewUser.email

                        if CheckoutCart.shared.isGuest == false {
                            // if the new user's stripe id is nill then this is the regular user creation process and a stripe id will be sent from the backend
                            CheckoutCart.shared.stripeId = fetchedUser.stripeId
                            requestedNewUser.stripeId = fetchedUser.stripeId

                            let sessionToken = response.headers["authorization-token"] as! String
                            try! SecureStore(secureStoreQueryable: GenericPasswordQueryable()).setValue(sessionToken, for: "sessionToken")
                            // set the token in the shopping cart and use it whenever calling the backend
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                                self.alertAccountCreationPreviouslyRegistered()
                            }
                        }
                        // the user is creating an account without having ordered something prior as a guest. this is the typical process which redirects to the home page
                        else {
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                                self.alertAccountCreationForGuestPreviouslyRegistered()
                                CoreDataManager.sharedManager.saveContext()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.alertError(message: "Your username is taken. Please choose another", title: "Username already exists")
                        }
                    }
                case let .failure(error): // if the API fails the enum API result will be of the type failure
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.alertError(message: "A network error has occured. Check your internet connection and if necessary, restart the app.", title: "Network Error")
                        print("error case .failure", error)
                    }
                }
            }
        }
    }

    private func alertAccountCreationForGuest() {
        return alert(
            title: "",
            message: "Welcome to QuickBev! You may now proceed with your order.",
            alertType: "accountCreationGuest"
        )
    }

    private func alertAccountCreationForGuestPreviouslyRegistered() {
        return alert(
            title: "",
            message: "Welcome to QuickBev! This email has already been used to create an account, but its still unverified. We've updated the account information to match what you just submitted. You may now proceed with your order.",
            alertType: "accountCreationGuest"
        )
    }

    private func alertAccountCreation() {
        return alert(
            title: "Welcome to QuickBev!",
            message: "",
            alertType: "accountCreation"
        )
    }

    private func alertAccountCreationPreviouslyRegistered() {
        return alert(
            title: "Welcome to QuickBev!",
            message: "This email has already been used to create an account, but its still unverified. We've updated the account information to match what you just submitted.",
            alertType: "accountCreation"
        )
    }

    private func alertError(message: String, title: String) {
        return alert(
            title: title,
            message: message,
            alertType: "error"
        )
    }

    private func alert(title: String, message: String, alertType: String) {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if alertType == "accountCreationGuest" {
            alertCtrl.addAction(UIAlertAction(title: "Okay", style: .cancel) { _ in
                let drinkViewController = DrinkViewController(drink: CheckoutCart.guestDrink!)
                let homePageViewController = HomePageViewController()
                let drinkListTableViewController = DrinkListTableViewController()
                self.navController.setViewControllers([drinkViewController, drinkListTableViewController, homePageViewController], animated: true)
            })
        } else if alertType == "accountCreation" {
            alertCtrl.addAction(UIAlertAction(title: "Okay", style: .cancel) { _ in
                self.navController.pushViewController(VerifyEmailViewController(), animated: true)
            })
        } else if alertType == "error" {
            alertCtrl.addAction(UIAlertAction(title: "Okay", style: .cancel) { _ in
                self.dismiss(animated: true, completion: nil)
            })
        }
        present(alertCtrl, animated: true, completion: nil)
    }
}
