//
//  VerifyEmailViewController.swift
//  QuickBev
//
//  Created by Peter Vail Driscoll II on 2/13/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class VerifyEmailViewController: UIViewController {
    @UsesAutoLayout var pickupDetailsStackView = UIStackView()
    @UsesAutoLayout var confirmationEmailLabel = UILabel(theme: Theme.UILabel(props: [.font(UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 19.458))), .textColor]))
    @UsesAutoLayout var pickupDetailsLabel = UILabel(theme: Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var resendConfirmationLabel = UILabel(theme: Theme.UILabel(props: [.font(UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 19.458))), .textColor]))
    @UsesAutoLayout var resendButton = RoundButton(theme: Theme.RoundButton(props: [.color, .text("Resend email"), .titleLabelFont(nil)]))
    @UsesAutoLayout private var activityIndicator = UIActivityIndicatorView(style: .large)
//    @UsesAutoLayout var addressLabel = UILabel(theme: Theme.UILabel(props: [.textColor]))
//    @UsesAutoLayout var pickupInstructionsLabel = UILabel(theme: Theme.UILabel(props: [.textColor]))
//    @UsesAutoLayout var pickupInstructionsText = UILabel(theme: Theme.UILabel(props: [.textColor]))
//    @UsesAutoLayout var toolbarView = ToolbarView()
//    var didLayoutBadgeNotification = false

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
        print(UIViewController.screenSize.width * 0.047)

        view.addSubview(pickupDetailsStackView)
        view.addSubview(resendButton)
        resendButton.addSubview(activityIndicator)
        activityIndicator.frame = resendButton.bounds
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.0)
//        view.addSubview(toolbarView)
        pickupDetailsStackView.addArrangedSubview(pickupDetailsLabel)
        pickupDetailsStackView.addArrangedSubview(confirmationEmailLabel)
        pickupDetailsStackView.addArrangedSubview(resendConfirmationLabel)
//        pickupDetailsStackView.addArrangedSubview(addressLabel)
//        pickupDetailsStackView.addArrangedSubview(pickupInstructionsLabel)
//        pickupDetailsStackView.addArrangedSubview(pickupInstructionsText)

        pickupDetailsStackView.axis = .vertical
        pickupDetailsStackView.spacing = 80

        pickupDetailsLabel.text = "Verify your email"
        pickupDetailsLabel.font = UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 40.0))
//        print("h", 20 / UIViewController.screenSize.height)
//        print("w", 20 / UIViewController.screenSize.width)
//        print("area", (UIViewController.screenSize.width * UIViewController.screenSize.height) / 20)
//        print(0.039409 * UIViewController.screenSize.height)
//        pickupAddressLabel.text = "Pickup address"
//        pickupAddressLabel.font = UIFont(name: "Charter-Black", size: 20.0)

        confirmationEmailLabel.text = "Check your email for the confirmation we sent you. Click the verify button and you'll be good to go!"
        confirmationEmailLabel.numberOfLines = 0
        confirmationEmailLabel.lineBreakMode = .byWordWrapping
//        confirmationEmailLabel.textAlignment = .center
//        resendConfirmationLabel.font = UIFont(name: "Charter-Roman", size: UIViewController.screenSize.width * 0.043478260869565216)
//        print("18.0/UIViewController.screenSize.width", 18.0 / UIViewController.screenSize.width)

        resendConfirmationLabel.text = "Didn't receive an email? Click the button below to send another one"
        resendConfirmationLabel.numberOfLines = 0
        resendConfirmationLabel.lineBreakMode = .byWordWrapping
//        resendConfirmationLabel.font = UIFont.themeLabelFont
//
//        pickupInstructionsLabel.text = "Pickup instructions"
//        pickupInstructionsLabel.font = UIFont(name: "Charter-Black", size: 20.0)
//
//        pickupInstructionsText.text = "Go to the second floor to the end of the business and tell business your name"
//        pickupInstructionsText.font = UIFont.themeLabelFont

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            pickupDetailsStackView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            pickupDetailsStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            pickupDetailsStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            resendButton.topAnchor.constraint(equalTo: pickupDetailsStackView.bottomAnchor, constant: UIViewController.screenSize.height * 0.05),
            resendButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            resendButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.43),
            resendButton.heightAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.1),
            activityIndicator.centerXAnchor.constraint(equalTo: resendButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: resendButton.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: activityIndicator.superview!.widthAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.superview!.heightAnchor),
//            pickupDetailsStackView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.80),
//            resendConfirmationLabel.heightAnchor.constraint(equalTo: resendConfirmationLabel.superview!.heightAnchor, multiplier: 0.3),
//            confirmationEmailLabel.heightAnchor.constraint(equalTo: confirmationEmailLabel.superview!.heightAnchor, multiplier: 0.3)
//            toolbarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
//            toolbarView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
//            toolbarView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
//            toolbarView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.12),
        ])
        resendButton.addTarget(self, action: #selector(firstButtonTouchUp), for: .touchUpInside)
    }

    @objc func firstButtonTouchUp() {
        resendButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()

        let request = try! APIRequest(method: .put, path: "/customer", body: CheckoutCart.shared.user)
        APIClient().perform(request) { result in
            DispatchQueue.main.async {
                self.resendButton.setTitle("Resend", for: .normal)
                self.activityIndicator.stopAnimating()
            }
            switch result {
            case let .success(response):
                print("successful resend email response", response)
            case let .failure(error):
                print("error resending email", error)
            }
        }
    }

//    @UsesAutoLayout var verificationStackView = UIStackView(theme: Theme.UIStackView(props: [.vertical, .spacing(10)]))
//    @UsesAutoLayout var verifyEmailLabel = UILabel(theme: Theme.UILabel(props: [.text("Your almost there!"), .font(nil), .textColor]))
//    @UsesAutoLayout var verifyEmailTextView = UITextView()
//
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        view.backgroundColor = .white
//    }
//
//    @available(*, unavailable)
//    required init?(coder _: NSCoder) {
//        fatalError("coder not set up")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.addSubview(verificationStackView)
//        verificationStackView.addSubview(verifyEmailLabel)
//        verificationStackView.addSubview(verifyEmailTextView)
//
//        verifyEmailTextView.font = UIFont(name: "Charter-Roman", size: 14.0)
//        verifyEmailTextView.textColor = .black
//        verifyEmailTextView.text = "Verify your account with the confirmation email we sent you.After verification, you will be automatically logged into the app"
//
//        let safeArea = view.safeAreaLayoutGuide
//
//        NSLayoutConstraint.activate([verificationStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
//                                     verificationStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
//                                     verificationStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10)])
//    }

    func listenForEmailVerificationStatus() {
        // display a message saying "email verified!" then switch to home page
        // possibly call this function from RootViewController by checking that the current page is this page, then leave the alert view controller stuff to be implemented here
        DispatchQueue.main.async {
            SceneDelegate.shared.rootViewController.switchToHomePageViewController()
        }
    }
}
