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
    var signInProps: SignInAndSignUpProps
    let moonImage = UIImage(named:"moon")
    
    @UsesAutoLayout var moonImageView = UIImageView()
    @UsesAutoLayout var centerLabel :UILabel = {
        if UIViewController.screenSize.height < 667 {
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
    @UsesAutoLayout var firstButton = RoundButton()
    @UsesAutoLayout var secondButton = RoundButton()
    @UsesAutoLayout var thirdButton = RoundButton()
    @UsesAutoLayout var orLabel = UILabel()
    init(frame: CGRect, props: SignInAndSignUpProps){
        // have to initialize view controller properties before calling super.init
        signInProps = props

        super.init(frame: frame)
        self.addSubview(moonImageView)
        self.addSubview(centerLabel)
        self.addSubview(optionsStackView)
        
        moonImageView.image = moonImage
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 14.0
        
        firstButton.refreshTitle(newTitle: props.getButtonText(actionProvider: SignInAndSignUpProps.ActionProvider.fb))
        firstButton.titleLabel?.font = UIFont(name: "Charter-Black", size: 20.0)
        firstButton.refreshColor(color:  UIColor.themeColor)
        
        secondButton.refreshTitle(newTitle: props.getButtonText(actionProvider: SignInAndSignUpProps.ActionProvider.google))
        secondButton.refreshColor(color:  UIColor.white)
        secondButton.titleLabel?.font = UIFont(name: "Charter-Black", size: 20.0)
        secondButton.setTitleColor(UIColor.black, for: .normal)
        thirdButton.refreshTitle(newTitle: props.getButtonText(actionProvider: SignInAndSignUpProps.ActionProvider.quickBev))
        thirdButton.titleLabel?.font = UIFont(name: "Charter-Black", size: 20.0)
        thirdButton.refreshColor(color:  UIColor.init(red: 134/255, green: 130/255, blue: 230/255, alpha: 1.0))
        
        orLabel.text = "OR"
        orLabel.font = UIFont(name: "Charter-Roman", size: 18.0)
        orLabel.textAlignment = .center
        
        centerLabel.text = props.getCenterTitleText()
        centerLabel.textAlignment = .center
        
        optionsStackView.addArrangedSubview(firstButton)
        optionsStackView.addArrangedSubview(secondButton)
        optionsStackView.addArrangedSubview(orLabel )
        optionsStackView.addArrangedSubview(thirdButton)
        
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            moonImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.45 ),

            moonImageView.heightAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.45),
            moonImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: (0.11 * UIViewController.screenSize.height)),
            moonImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
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
        signInProps.launchNewViewController(actionProvider: SignInAndSignUpProps.ActionProvider.fb, splash: true)
    }
    @objc func secondButtonTouchUp () {
        signInProps.launchNewViewController(actionProvider: SignInAndSignUpProps.ActionProvider.google, splash: true)
    }
    @objc func thirdButtonTouchUp () {
        signInProps.launchNewViewController(actionProvider: SignInAndSignUpProps.ActionProvider.quickBev, splash: true)
    }
}


