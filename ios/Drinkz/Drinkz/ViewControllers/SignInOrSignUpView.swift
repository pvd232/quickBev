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
    private lazy var navigationController: UINavigationController = {
        return SceneDelegate.shared.rootViewController.current as! UINavigationController
    }()
    
    var shouldSetupConstraints = true
    var viewProps: SignInAndSignUpProps
    let logoImage = UIImage(named:"charterRomanPurpleLogo-30")
    
    @UsesAutoLayout var logoImageView = UIImageView()
    @UsesAutoLayout var centerLabel :UILabel = {
        if UIViewController.screenSize.height <= 736 {
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
    
    lazy var logoMultiplier: Float = { if UIViewController.screenSize.height <= 736 {
        print("wee")
        return 0.565217
        }
        else {
            return 0.65
        }
    }()
    
    @UsesAutoLayout var optionsStackView = UIStackView()
    @UsesAutoLayout var firstButton = RoundButton()
    @UsesAutoLayout var secondButton = RoundButton()
    @UsesAutoLayout var thirdButton = RoundButton()
    @UsesAutoLayout var orLabel = UILabel()
    
    init(frame: CGRect, props: SignInAndSignUpProps){
        // have to initialize view controller properties before calling super.init
        viewProps = props
        super.init(frame: frame)
        self.addSubview(logoImageView)
        self.addSubview(centerLabel)
        self.addSubview(optionsStackView)
        
        logoImageView.image = logoImage
        logoImageView.layer.cornerRadius = 20.0
        logoImageView.clipsToBounds = true
        logoImageView.contentMode = .scaleToFill
        
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 14.0
        
        firstButton.refreshTitle(newTitle: props.getButtonText(buttonIndex: SignInAndSignUpProps.ButtonIndex.first))
        firstButton.titleLabel?.font = UIFont(name: "Charter-Black", size: 20.0)
        firstButton.refreshColor(color:  UIColor.themeColor)
        
        secondButton.refreshTitle(newTitle: props.getButtonText(buttonIndex: SignInAndSignUpProps.ButtonIndex.second))
        if props.getRawValue() == "splash"{
            secondButton.refreshColor(color:  UIColor.themeColor)
            secondButton.setTitleColor(UIColor.white, for: .normal)

        }
        else {
            secondButton.refreshColor(color: UIColor.white)
            secondButton.setTitleColor(UIColor.black, for: .normal)
        }
        secondButton.titleLabel?.font = UIFont(name: "Charter-Black", size: 20.0)
        thirdButton.refreshTitle(newTitle: props.getButtonText(buttonIndex: SignInAndSignUpProps.ButtonIndex.third))
        thirdButton.titleLabel?.font = UIFont(name: "Charter-Black", size: 20.0)
        thirdButton.refreshColor(color:  UIColor.init(red: 134/255, green: 130/255, blue: 230/255, alpha: 1.0))
        
        orLabel.text = "OR"
        orLabel.font = UIFont(name: "Charter-Roman", size: 18.0)
        orLabel.textAlignment = .center
        
        centerLabel.text = props.getCenterTitleText()
        centerLabel.textAlignment = .center
        centerLabel.textColor = UIColor.black
        
        
        optionsStackView.addArrangedSubview(firstButton)
        optionsStackView.addArrangedSubview(secondButton)
        optionsStackView.addArrangedSubview(orLabel )
        optionsStackView.addArrangedSubview(thirdButton)
        
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: CGFloat(logoMultiplier) ),
            logoImageView.heightAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: CGFloat(logoMultiplier)),
            logoImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: (0.02 * UIViewController.screenSize.height)),
            logoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
        firstButton.widthAnchor.constraint(equalTo: firstButton.heightAnchor, multiplier: (197/25)),
        secondButton.widthAnchor.constraint(equalTo: secondButton.heightAnchor, multiplier: (197/25)),
        thirdButton.widthAnchor.constraint(equalTo: thirdButton.heightAnchor, multiplier: (197/25)),

        optionsStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
        optionsStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20.0),
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

        viewProps.launchNewViewController(buttonIndex: SignInAndSignUpProps.ButtonIndex.first)
    }
    @objc func secondButtonTouchUp () {
        viewProps.launchNewViewController(buttonIndex:  SignInAndSignUpProps.ButtonIndex.second)
    }
    @objc func thirdButtonTouchUp () {
        viewProps.launchNewViewController(buttonIndex: SignInAndSignUpProps.ButtonIndex.third)
    }
}


