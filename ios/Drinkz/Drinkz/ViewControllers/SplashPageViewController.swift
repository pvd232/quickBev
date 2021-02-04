//
//  SplashPageViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/3/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import Stripe


class SplashPageViewController: UIViewController {
    
    @UsesAutoLayout var moonImageView = UIImageView()
    let moonImage = UIImage(named:"moon")
    @UsesAutoLayout var letsGetStartedLabel :UILabel = {
        print("screenSize.height", screenSize.height)
        if screenSize.height < 667 {
            let smallFontUILabel = UILabel()
            smallFontUILabel.font =  UIFont(name: "Charter-Roman", size: 26.0)
            return smallFontUILabel
        }
        else {
            let largeFontUILabel = UILabel()
            largeFontUILabel.font = UIFont(name: "Charter-Roman", size: 36.0)
            return largeFontUILabel
        }
    }()
    @UsesAutoLayout var optionsStackView = UIStackView()
    @UsesAutoLayout var signInButton = RoundButton()
    @UsesAutoLayout var createAnAccountButton = RoundButton()
    @UsesAutoLayout var continueAsGuestButton = RoundButton()
    @UsesAutoLayout var orLabel = UILabel()
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder not set up")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moonImageView.image = moonImage
        
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 14.0
        
        signInButton.refreshTitle(newTitle: "Sign in to QuickBev")
        signInButton.titleLabel?.font = UIFont(name: "Charter-Black", size: 20.0)
        signInButton.refreshColor(color:  UIColor.init(red: 134/255, green: 130/255, blue: 230/255, alpha: 1.0))
        createAnAccountButton.refreshTitle(newTitle: "Create a QuickBev account")
        createAnAccountButton.refreshColor(color:  UIColor.init(red: 134/255, green: 130/255, blue: 230/255, alpha: 1.0))
        createAnAccountButton.titleLabel?.font = UIFont(name: "Charter-Black", size: 20.0)
        
        continueAsGuestButton.refreshTitle(newTitle: "Continue as a guest")
        continueAsGuestButton.titleLabel?.font = UIFont(name: "Charter-Black", size: 20.0)
        continueAsGuestButton.refreshColor(color:  UIColor.init(red: 134/255, green: 130/255, blue: 230/255, alpha: 1.0))
        orLabel.text = "OR"
        orLabel.font = UIFont(name: "Charter-Roman", size: 18.0)
        orLabel.textAlignment = .center
        letsGetStartedLabel.text = "Let's Get Started"
        letsGetStartedLabel.font = UIFont(name: "Charter-Roman", size: 36.0)
        letsGetStartedLabel.textAlignment = .center
        
        optionsStackView.addArrangedSubview(signInButton)
        optionsStackView.addArrangedSubview(createAnAccountButton)
        optionsStackView.addArrangedSubview(orLabel )
        optionsStackView.addArrangedSubview(continueAsGuestButton)
        
        self.view.addSubview(moonImageView)
        self.view.addSubview(letsGetStartedLabel)
        self.view.addSubview(optionsStackView)
        let margins = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            moonImageView.heightAnchor.constraint(equalTo: moonImageView.widthAnchor),
            moonImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40.0),
            moonImageView.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            signInButton.widthAnchor.constraint(equalTo: signInButton.heightAnchor, multiplier: (197/25)),
            createAnAccountButton.widthAnchor.constraint(equalTo: createAnAccountButton.heightAnchor, multiplier: (197/25)),
            
            continueAsGuestButton.widthAnchor.constraint(equalTo: continueAsGuestButton.heightAnchor, multiplier: (197/25)),
            
            optionsStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -10.0),
            optionsStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10.0),
            optionsStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20.0).usingPriority(UILayoutPriority(751)),
            optionsStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10.0),

            letsGetStartedLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            letsGetStartedLabel.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
            letsGetStartedLabel.topAnchor.constraint(equalTo: moonImageView.bottomAnchor, constant: 60.0).usingPriority(UILayoutPriority(750)),
            letsGetStartedLabel.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.07),
        ])
        moonImageView.setContentHuggingPriority( UILayoutPriority(251.0), for:.vertical)
        moonImageView.setContentHuggingPriority( UILayoutPriority(251.0), for:.horizontal)
        moonImageView.setContentCompressionResistancePriority(UILayoutPriority(1), for: .vertical)
        moonImageView.setContentCompressionResistancePriority(UILayoutPriority(1), for: .horizontal)
        letsGetStartedLabel.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        letsGetStartedLabel.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        optionsStackView.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        optionsStackView.setContentHuggingPriority(UILayoutPriority(250), for: .vertical)
        orLabel.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        orLabel.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        orLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        signInButton.addTarget(self, action: #selector(signInButtonTouchup), for: .touchUpInside)
        createAnAccountButton.addTarget(self, action: #selector(createAQuickBevAccountButtonTouchup), for: .touchUpInside)
        continueAsGuestButton.addTarget(self, action: #selector(continueAsGuestButtonTouchup), for: .touchUpInside)
    }
    
    @objc func signInButtonTouchup() {
        let nextViewController = SignInSplashPageViewController()
        self.navigationController!.pushViewController(nextViewController, animated: true)
    }
    
    @objc func createAQuickBevAccountButtonTouchup() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let nextViewController = storyboard.instantiateViewController(identifier: "RegistrationSplashPageViewController") as? RegistrationSplashPageViewController {
            self.navigationController!.pushViewController(nextViewController, animated: true)
        }
    }
    
    @objc func continueAsGuestButtonTouchup() {
        let nextViewController = HomePageViewController()
        self.navigationController!.pushViewController(nextViewController, animated: true)
    }
    
}
