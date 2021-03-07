//
//  VerifyEmailViewController.swift
//  QuickBev
//
//  Created by Peter Vail Driscoll II on 2/13/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class VerifyEmailViewController: UIViewController {
    @UsesAutoLayout var verifyEmailStackView = UIStackView()
    @UsesAutoLayout var confirmationEmailLabel = UILabel(theme: Theme.UILabel(props: [.font(UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 19.458))), .textColor]))
    @UsesAutoLayout var verifyEmailLabel = UILabel(theme: Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var resendConfirmationLabel = UILabel(theme: Theme.UILabel(props: [.font(UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 19.458))), .textColor]))
    @UsesAutoLayout var resendButton = RoundButton(theme: Theme.RoundButton(props: [.color, .text("Resend email"), .titleLabelFont(nil)]))
    @UsesAutoLayout private var activityIndicator = UIActivityIndicatorView(style: .large)

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

        view.addSubview(verifyEmailStackView)
        view.addSubview(resendButton)
        resendButton.addSubview(activityIndicator)
        activityIndicator.frame = resendButton.bounds
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.0)
        verifyEmailStackView.addArrangedSubview(verifyEmailLabel)
        verifyEmailStackView.addArrangedSubview(confirmationEmailLabel)
        verifyEmailStackView.addArrangedSubview(resendConfirmationLabel)
        verifyEmailStackView.axis = .vertical
        verifyEmailStackView.spacing = 80

        verifyEmailLabel.text = "Verify your email"
        verifyEmailLabel.font = UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 40.0))

        confirmationEmailLabel.text = "Check your email for the confirmation we sent you. Click the verify button and you'll be good to go!"
        confirmationEmailLabel.numberOfLines = 0
        confirmationEmailLabel.lineBreakMode = .byWordWrapping

        resendConfirmationLabel.text = "Didn't receive an email? Click the button below to send another one"
        resendConfirmationLabel.numberOfLines = 0
        resendConfirmationLabel.lineBreakMode = .byWordWrapping

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            verifyEmailStackView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            verifyEmailStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            verifyEmailStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            resendButton.topAnchor.constraint(equalTo: verifyEmailStackView.bottomAnchor, constant: UIViewController.screenSize.height * 0.05),
            resendButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            resendButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.43),
            resendButton.heightAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.1),
            activityIndicator.centerXAnchor.constraint(equalTo: resendButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: resendButton.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: activityIndicator.superview!.widthAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.superview!.heightAnchor),
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
}
