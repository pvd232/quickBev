//
//  RegistrationSplashPageViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 12/1/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class RegistrationSplashPageViewController: UIViewController {
    @UsesAutoLayout var signUpSplashView = UIView()

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
//        signUpSplashView = SignInOrSignUpView(frame: self.view.frame, props: SignInAndSignUpProps.UserAction( action: .signUp))
        view.addSubview(signUpSplashView)

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([signUpSplashView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                                     signUpSplashView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                                     signUpSplashView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                                     signUpSplashView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)])
    }
}
