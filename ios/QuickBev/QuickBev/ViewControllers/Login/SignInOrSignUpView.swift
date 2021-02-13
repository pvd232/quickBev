//
//  SignInOrSignUpView.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 2/3/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
class SignInOrSignUpView: UIView {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var navController: UINavigationController = {
        return SceneDelegate.shared.rootViewController.current as! UINavigationController
    }()

    var shouldSetupConstraints = true
//    var viewProps: SignInAndSignUpProps
    let logoImage = UIImage(named:"charterRomanPurpleLogo-30")
    
    @UsesAutoLayout var logoImageView = UIImageView()
    @UsesAutoLayout var centerLabel = UILabel(theme: Theme.UILabel(props: [.font(    UIFont.largeThemeLabelFont), .text("Lets get started"), .textColor]))
    @UsesAutoLayout var optionsStackView = UIStackView()
    @UsesAutoLayout var firstButton = RoundButton(theme: Theme.RoundButton(props: [.color, .text("Sign in"), .titleLabelFont(UIFont.themeButtonFont)]))
    @UsesAutoLayout var secondButton = RoundButton(theme: Theme.RoundButton(props: [.color, .text("Sign up"), .titleLabelFont(UIFont.themeButtonFont)]))
    @UsesAutoLayout var thirdButton = RoundButton(theme: Theme.RoundButton(props: [.color, .text("Continue as a guest"), .titleLabelFont(UIFont.themeButtonFont)]))
    @UsesAutoLayout var orLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    
    override init(frame: CGRect){
        // have to initialize view controller properties before calling super.init
//        viewProps = props
        super.init(frame: frame)
        self.addSubview(logoImageView)
        self.addSubview(centerLabel)
        self.addSubview(optionsStackView)
        
        logoImageView.image = logoImage
        
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 14.0
        
//        firstButton.refreshTitle(newTitle: props.getButtonText())
//        firstButton.titleLabel?.font = UIFont.themeButtonFont
//        firstButton.refreshColor(color:  UIColor.themeColor)
        
//        secondButton.refreshTitle(newTitle: props.getButtonText())
//        if props.getRawValue() == "splash"{
//            secondButton.refreshColor(color:  UIColor.themeColor)
//            secondButton.setTitleColor(UIColor.white, for: .normal)

//        }
//        else {
//            secondButton.refreshColor(color: UIColor.white)
//            secondButton.setTitleColor(UIColor.black, for: .normal)
//        }
//        secondButton.titleLabel?.font = UIFont.themeButtonFont
//        thirdButton.refreshTitle(newTitle: props.getButtonText())
//        thirdButton.titleLabel?.font = UIFont.themeButtonFont
//        thirdButton.refreshColor(color:  UIColor.themeColor)
        
        orLabel.text = "OR"
        orLabel.font = UIFont(name: "Charter-Roman", size: 18.0)
        orLabel.textAlignment = .center
        
//        centerLabel.text = props.getCenterTitleText()
        centerLabel.textAlignment = .center
        centerLabel.textColor = UIColor.black
        
        
        optionsStackView.addArrangedSubview(firstButton)
        optionsStackView.addArrangedSubview(secondButton)
        optionsStackView.addArrangedSubview(orLabel )
        optionsStackView.addArrangedSubview(thirdButton)
        
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: CGFloat(Double.logoSizeMultiplier) ),
            logoImageView.heightAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: CGFloat(Double.logoSizeMultiplier)),
            logoImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: (0.02 * UIViewController.screenSize.height)),
            logoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
        firstButton.widthAnchor.constraint(equalTo: firstButton.heightAnchor, multiplier: (197/25)),
        secondButton.widthAnchor.constraint(equalTo: secondButton.heightAnchor, multiplier: (197/25)),
        thirdButton.widthAnchor.constraint(equalTo: thirdButton.heightAnchor, multiplier: (197/25)),

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
        if(shouldSetupConstraints) {
            // AutoLayout constraints
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    @objc func firstButtonTouchUp () {

        navController.pushViewController(LoginViewController(), animated: true)

    }
    @objc func secondButtonTouchUp () {
        navController.pushViewController(RegistrationWithEmailViewController(), animated: true)
    }
    @objc func thirdButtonTouchUp () {
        CheckoutCart.shared.isGuest = true
        CoreDataManager.sharedManager.saveContext()
        navController.pushViewController(HomePageViewController(), animated: true)
    }
}


