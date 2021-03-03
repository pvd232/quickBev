//
//  emailResetViewController.swift
//  QuickBev
//
//  Created by Peter Vail Driscoll II on 2/28/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
class PasswordResetViewController: UIViewController, UITextFieldDelegate {
    @UsesAutoLayout var pageLabel = UILabel(theme: Theme.UILabel(props: [.font(UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 40))), .textColor, .text("Reset your password")]))
    @UsesAutoLayout var emailTextField = RoundedUITextField(theme: Theme.UITextField(props: [.font(nil), .placeHolderText("Your email"), .autocapitalizationType(autocapitalizationType: .none), .borderStyle(borderStyle: .roundedRect), .backgroundColor(UIColor.clear)]))
    @UsesAutoLayout var confirmEmailTextField = RoundedUITextField(theme: Theme.UITextField(props: [.font(nil), .placeHolderText("Confirm your email"), .autocapitalizationType(autocapitalizationType: .none), .borderStyle(borderStyle: .roundedRect), .backgroundColor(UIColor.clear)]))
    @UsesAutoLayout var emailLabel = UILabel(theme: Theme.UILabel(props: [.text("Email"), .font(nil), .textColor]))
    @UsesAutoLayout var confirmEmailLabel = UILabel(theme: Theme.UILabel(props: [.text("Confirm email"), .font(nil), .textColor]))
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
        view.addSubview(pageLabel)
        view.addSubview(registrationStackView)
        view.addSubview(submitButton)
        view.addSubview(activityIndicator)
        activityIndicator.frame = submitButton.bounds

        submitButton.addSubview(activityIndicator)
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.0)
        registrationStackView.addArrangedSubview(emailLabel)
        registrationStackView.addArrangedSubview(emailTextField)
        registrationStackView.addArrangedSubview(confirmEmailLabel)
        registrationStackView.addArrangedSubview(confirmEmailTextField)

        emailTextField.delegate = self
        confirmEmailTextField.delegate = self

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            pageLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10.0),
            pageLabel.bottomAnchor.constraint(equalTo: registrationStackView.topAnchor, constant: -40.0),
            pageLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),

            registrationStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
            registrationStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),

            submitButton.topAnchor.constraint(equalTo: registrationStackView.bottomAnchor, constant: UIViewController.screenSize.height * 0.05),
            submitButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            submitButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.43),
            submitButton.heightAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.1),
//            submitButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
//            submitButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
//            submitButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.43),
//            submitButton.heightAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.1),

            activityIndicator.centerXAnchor.constraint(equalTo: submitButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: activityIndicator.superview!.widthAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.superview!.heightAnchor),

            emailTextField.widthAnchor.constraint(equalTo: emailTextField.heightAnchor, multiplier: 197 / 25),
            confirmEmailTextField.widthAnchor.constraint(equalTo: confirmEmailTextField.heightAnchor, multiplier: 197 / 25),

        ])

        submitButton.addTarget(self, action: #selector(submitRegistration), for: .touchUpInside)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.placeholder == "Your email" {
            formValues["email"] = textField.text
        }
        if textField.placeholder == "Confirm your email" {
            formValues["confirmEmail"] = textField.text
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.placeholder == "Your email" {
            formValues["email"] = textField.text
        }
        if textField.placeholder == "Confirm your email" {
            formValues["confirmEmail"] = textField.text
        }
        return true
    }

    @objc private func submitRegistration(_: RoundButton) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }

        var title = ""
        var message = ""

        if formValues["email"] != formValues["confirmEmail"] {
            title = "email mismatch"
            message = "email and confirmation email are different. Please correct them and resubmit"

            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Try again", style: .cancel) { _ in
                self.dismiss(animated: true)
            })
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.present(alertController, animated: true, completion: nil)
            }

        } else {
            let request = APIRequest(method: .get, path: "/reset-password/\(formValues["email"]!)")
            APIClient().perform(request) { result in
                switch result {
                case let .success(response):
                    if response.statusCode == 200 {
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.alert(title: "Password reset email sent", message: "If that email was valid, we sent you an email to reset your email!")
                        }
                    } else {
                        print("bad response", response.statusCode)
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                        }
                    }
                case let .failure(error):
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }

                    print("error reset pwd", error)
                }
            }
        }
    }

    private func alert(title: String, message: String) {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: "Okay", style: .cancel) { _ in
            self.dismiss(animated: true)
        })
        present(alertCtrl, animated: true, completion: nil)
    }
}
