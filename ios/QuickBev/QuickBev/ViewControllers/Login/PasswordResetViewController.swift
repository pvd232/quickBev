//
//  PasswordResetViewController.swift
//  QuickBev
//
//  Created by Peter Vail Driscoll II on 2/28/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
class PasswordResetViewController: UIViewController {
    @UsesAutoLayout var pageLabel = UILabel(theme: Theme.UILabel(props: [.text("Reset Password"), .font(UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 30.0))), .textColor]))
    @UsesAutoLayout var passwordResetStackView = UIStackView(theme: Theme.UIStackView(props: [.vertical, .spacing(10)]))
    @UsesAutoLayout var passwordLabel = UILabel(theme: Theme.UILabel(props: [.text("Enter Password"), .font(nil), .textColor]))
    @UsesAutoLayout var confirmPasswordLabel = UILabel(theme: Theme.UILabel(props: [.text("Confirm Password"), .font(nil), .textColor]))
    @UsesAutoLayout var passwordTextField = RoundedUITextField(theme: Theme.UITextField(props: [.borderStyle(borderStyle: .roundedRect), .font(nil)]))
    @UsesAutoLayout var confirmPasswordTextField = RoundedUITextField(theme: Theme.UITextField(props: [.borderStyle(borderStyle: .roundedRect), .font(nil)]))

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
        view.addSubview(passwordResetStackView)
        view.addSubview(passwordLabel)
        view.addSubview(confirmPasswordLabel)

        passwordResetStackView.addArrangedSubview(passwordLabel)
        passwordResetStackView.addArrangedSubview(passwordTextField)
        passwordResetStackView.addArrangedSubview(confirmPasswordLabel)
        passwordResetStackView.addArrangedSubview(confirmPasswordTextField)

        NSLayoutConstraint.activate([
            // TODO: finish setting up page
        ])
    }
}
