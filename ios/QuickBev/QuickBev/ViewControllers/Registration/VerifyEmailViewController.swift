//
//  VerifyEmailViewController.swift
//  QuickBev
//
//  Created by Peter Vail Driscoll II on 2/13/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class VerifyEmailViewController: UIViewController {
    @UsesAutoLayout var verificationStackView = UIStackView(theme: Theme.UIStackView(props: [.vertical, .spacing(10)]))
    @UsesAutoLayout var verifyEmailLabel = UILabel(theme: Theme.UILabel(props: [.text("Your almost there!"), .font(nil), .textColor]))
    @UsesAutoLayout var verifyEmailTextView = UITextView()

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

        view.addSubview(verificationStackView)
        verificationStackView.addSubview(verifyEmailLabel)
        verificationStackView.addSubview(verifyEmailTextView)

        verifyEmailTextView.font = UIFont(name: "Charter-Roman", size: 14.0)
        verifyEmailTextView.textColor = .black
        verifyEmailTextView.text = "Verify your account with the confirmation email we sent you.After verification, you will be automatically logged into the app"

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([verificationStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
                                     verificationStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
                                     verificationStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10)])
    }

    func listenForEmailVerificationStatus() {
        // display a message saying "email verified!" then switch to home page
        // possibly call this function from RootViewController by checking that the current page is this page, then leave the alert view controller stuff to be implemented here
        DispatchQueue.main.async {
            SceneDelegate.shared.rootViewController.switchToHomePageViewController()
        }
    }
}
