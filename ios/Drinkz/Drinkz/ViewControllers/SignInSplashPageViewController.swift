//
//  SignInSplashPageViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/8/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class SignInSplashPageViewController: UIViewController {
    @UsesAutoLayout var signInView = UIView()
//    @UsesAutoLayout var moonImageView = UIImageView()
//
//    let moonImage = UIImage(named:"moon")
//    @UsesAutoLayout var signInToQuickBevLabel :UILabel = {
//        if SignInSplashPageViewController.screenSize.height < 667 {
//                let smallFontUILabel = UILabel()
//                smallFontUILabel.font =  UIFont(name: "Charter-Roman", size: 26.0)
//                return smallFontUILabel
//            }
//            else {
//                let largeFontUILabel = UILabel()
//                largeFontUILabel.font = UIFont(name: "Charter-Roman", size: 36.0)
//                return largeFontUILabel
//            }
//    }()
//    @UsesAutoLayout var optionsStackView = UIStackView()
//    @UsesAutoLayout var signInWithFacebookButton = RoundButton()
//    @UsesAutoLayout var signInWithGoogleButton = RoundButton()
//    @UsesAutoLayout var signInWithEmailButton = RoundButton()
//    @UsesAutoLayout var orLabel = UILabel()
    init() {
        super.init(nibName: nil, bundle: nil)

        self.view.backgroundColor = .systemBackground

    }
    
    required init?(coder: NSCoder) {
        fatalError("coder not set up")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        signInView = SignInOrSignUpView(frame: self.view.frame, props: SignInAndSignUpProps.UserAction( action: .signIn))
        self.view.addSubview(signInView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([signInView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                                     signInView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                                     signInView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                                     signInView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
//        moonImageView.image = moonImage
//
//        optionsStackView.axis = .vertical
//        optionsStackView.spacing = 14.0
//
//        signInWithFacebookButton.refreshTitle(newTitle: "Sign in with Facebook")
//        signInWithFacebookButton.titleLabel?.font = UIFont(name: "Charter-Black", size: 20.0)
//        signInWithFacebookButton.refreshColor(color:  UIColor.init(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0))
//
//        signInWithGoogleButton.refreshTitle(newTitle: "Sign in with Google")
//        signInWithGoogleButton.refreshColor(color:  UIColor.white)
//        signInWithGoogleButton.titleLabel?.font = UIFont(name: "Charter-Black", size: 20.0)
//        signInWithGoogleButton.setTitleColor(UIColor.black, for: .normal)
//        signInWithEmailButton.refreshTitle(newTitle: "Sign in with email")
//        signInWithEmailButton.titleLabel?.font = UIFont(name: "Charter-Black", size: 20.0)
//        signInWithEmailButton.refreshColor(color:  UIColor.init(red: 134/255, green: 130/255, blue: 230/255, alpha: 1.0))
//
//        orLabel.text = "OR"
//        orLabel.font = UIFont(name: "Charter-Roman", size: 18.0)
//        orLabel.textAlignment = .center
//
//        signInToQuickBevLabel.text = "Sign in to QuickBev"
//        signInToQuickBevLabel.textAlignment = .center
//
//        optionsStackView.addArrangedSubview(signInWithFacebookButton)
//        optionsStackView.addArrangedSubview(signInWithGoogleButton)
//        optionsStackView.addArrangedSubview(orLabel )
//        optionsStackView.addArrangedSubview(signInWithEmailButton)
//
//        self.view.addSubview(moonImageView)
//        self.view.addSubview(signInToQuickBevLabel)
//        self.view.addSubview(optionsStackView)
//
//        let margins = self.view.safeAreaLayoutGuide
//
//        NSLayoutConstraint.activate([
//            moonImageView.heightAnchor.constraint(equalTo: moonImageView.widthAnchor),
//            moonImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40.0),
//            moonImageView.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
//
//            signInWithFacebookButton.widthAnchor.constraint(equalTo: signInWithFacebookButton.heightAnchor, multiplier: (197/25)),
//            signInWithGoogleButton.widthAnchor.constraint(equalTo: signInWithGoogleButton.heightAnchor, multiplier: (197/25)),
//
//            signInWithEmailButton.widthAnchor.constraint(equalTo: signInWithEmailButton.heightAnchor, multiplier: (197/25)),
//
//            optionsStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -10.0),
//            optionsStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10.0),
//            optionsStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20.0).usingPriority(UILayoutPriority(751)),
//            optionsStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10.0),
//
//            signInToQuickBevLabel.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
//            signInToQuickBevLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
//            signInToQuickBevLabel.topAnchor.constraint(equalTo: moonImageView.bottomAnchor, constant: 60.0).usingPriority(UILayoutPriority(750)),
//            signInToQuickBevLabel.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.07),
//        ])
        
//        moonImageView.setContentHuggingPriority( UILayoutPriority(251.0), for:.vertical)
//        moonImageView.setContentHuggingPriority( UILayoutPriority(251.0), for:.horizontal)
//        moonImageView.setContentCompressionResistancePriority(UILayoutPriority(1), for: .vertical)
//        moonImageView.setContentCompressionResistancePriority(UILayoutPriority(1), for: .horizontal)
//       
//        signInToQuickBevLabel.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
//        signInToQuickBevLabel.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
//       
//        optionsStackView.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
//        optionsStackView.setContentHuggingPriority(UILayoutPriority(250), for: .vertical)
//       
//        orLabel.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
//        orLabel.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
//        orLabel.setContentCompressionResistancePriority(UILayoutPriority(800), for: .vertical)
//        orLabel.setContentCompressionResistancePriority(UILayoutPriority(800), for: .horizontal)
//       
//        signInWithFacebookButton.addTarget(self, action: #selector(signInWithFacebookButtonTouchup), for: .touchUpInside)
//        signInWithGoogleButton.addTarget(self, action: #selector(signInWithGoogleButtonTouchup), for: .touchUpInside)
//        signInWithEmailButton.addTarget(self, action: #selector(signInWithEmailButtonTouchup), for: .touchUpInside)
    }
    
//    @objc func signInWithFacebookButtonTouchup() {
//    }
//
//    @objc func signInWithGoogleButtonTouchup() {
//    }
//
//    @objc func signInWithEmailButtonTouchup() {
//        let nextViewController = LoginViewController()
//        self.navigationController?.pushViewController(nextViewController, animated: true)
//    }
}
