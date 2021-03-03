//
//  SignInOrSignUpView.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 2/3/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
class SplashView: UIView {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var navController: UINavigationController = {
        SceneDelegate.shared.rootViewController.current as! UINavigationController
    }()

    var shouldSetupConstraints = true
    let logoImage = UIImage(named: "charterRomanPurpleLogo-30")

    @UsesAutoLayout var logoImageView = UIImageView()
    @UsesAutoLayout var centerLabel = UILabel(theme: Theme.UILabel(props: [.font(UIFont.largeThemeLabelFont), .text("Lets get started"), .textColor]))
    @UsesAutoLayout var optionsStackView = UIStackView()
    @UsesAutoLayout var firstButton = RoundButton(theme: Theme.RoundButton(props: [.color, .text("Sign in"), .titleLabelFont(UIFont.themeButtonFont)]))
    @UsesAutoLayout var secondButton = RoundButton(theme: Theme.RoundButton(props: [.color, .text("Sign up"), .titleLabelFont(UIFont.themeButtonFont)]))
    @UsesAutoLayout var thirdButton = RoundButton(theme: Theme.RoundButton(props: [.color, .text("Continue as a guest"), .titleLabelFont(UIFont.themeButtonFont)]))
    @UsesAutoLayout var orLabel = UILabel(theme: Theme.UILabel(props: [.textColor]))

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(logoImageView)
        addSubview(centerLabel)
        addSubview(optionsStackView)

        logoImageView.image = logoImage

        optionsStackView.axis = .vertical
        optionsStackView.spacing = 14.0

        orLabel.text = "OR"
        orLabel.font = UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 18.0))
        orLabel.textAlignment = .center

        centerLabel.textAlignment = .center
        centerLabel.textColor = UIColor.black

        optionsStackView.addArrangedSubview(firstButton)
        optionsStackView.addArrangedSubview(secondButton)
        optionsStackView.addArrangedSubview(orLabel)
        optionsStackView.addArrangedSubview(thirdButton)

        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: CGFloat(Double.logoSizeMultiplier)),
            logoImageView.heightAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: CGFloat(Double.logoSizeMultiplier)),
            logoImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0.02 * UIViewController.screenSize.height),
            logoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            firstButton.widthAnchor.constraint(equalTo: firstButton.heightAnchor, multiplier: 197 / 25),
            secondButton.widthAnchor.constraint(equalTo: secondButton.heightAnchor, multiplier: 197 / 25),
            thirdButton.widthAnchor.constraint(equalTo: thirdButton.heightAnchor, multiplier: 197 / 25),

            optionsStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
            optionsStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10.0),
            optionsStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),

            centerLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            centerLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            centerLabel.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.07),
        ])
        firstButton.addTarget(self, action: #selector(firstButtonTouchUp), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(secondButtonTouchUp), for: .touchUpInside)
        thirdButton.addTarget(self, action: #selector(thirdButtonTouchUp), for: .touchUpInside)
    }

    override func updateConstraints() {
        // only want to update the contraints once
        if shouldSetupConstraints {
            // AutoLayout constraints
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }

    @objc func firstButtonTouchUp() {
        navController.pushViewController(LoginViewController(), animated: true)
    }

    @objc func secondButtonTouchUp() {
        navController.pushViewController(RegistrationWithEmailViewController(), animated: true)
    }

    @objc func thirdButtonTouchUp() {
        CheckoutCart.shared.isGuest = true
        let userCredentials: [HTTPHeader] = [HTTPHeader(field: "DeviceToken", value: CheckoutCart.shared.deviceToken)]
        let request = try! APIRequest(method: .post, path: "/guest-device-token", headers: userCredentials)
        APIClient().perform(request) {
            result in
            switch result {
            case let .success(response):
                print("success posting device token for guest", response)
                let sessionToken = response.headers["authorization-token"] as! String
                try? SecureStore(secureStoreQueryable: GenericPasswordQueryable()).setValue(sessionToken, for: "sessionToken")
            case let .failure(error):
                print("failure posting device token", error)
            }
        }
        CoreDataManager.sharedManager.saveContext()
        navController.pushViewController(HomePageViewController(), animated: true)
    }
}
