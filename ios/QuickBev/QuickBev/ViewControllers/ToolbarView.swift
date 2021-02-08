//
//  ToolbarView.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 2/2/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import BadgeHub

class ToolbarView: UIView {
    @UsesAutoLayout var bottomButtonsStackView = UIStackView()
    @UsesAutoLayout var orderButton = UIButton()
    @UsesAutoLayout var accountButton = UIButton()
    @UsesAutoLayout var eventsButton = UIButton()
    @UsesAutoLayout var homeButton = UIButton()
     var hub : BadgeHub?

    var shouldSetupConstraints = true
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var navigationController: UINavigationController = {
        return SceneDelegate.shared.rootViewController.current as! UINavigationController
    }()
    
    private lazy var rootViewController: RootViewController = {
        return SceneDelegate.shared.rootViewController
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        hub = BadgeHub(view: orderButton)

        self.addSubview(bottomButtonsStackView)
        self.backgroundColor = UIColor.themeColor
        
        hub!.scaleCircleSize(by: 0.85)
        hub!.setCount(CheckoutCart.shared.cart.count)

        bottomButtonsStackView.axis = .horizontal
        bottomButtonsStackView.distribution = .fillProportionally
        bottomButtonsStackView.alignment = .top
        bottomButtonsStackView.spacing = 30
        bottomButtonsStackView.addArrangedSubview(homeButton)
        bottomButtonsStackView.addArrangedSubview(eventsButton)
        bottomButtonsStackView.addArrangedSubview(accountButton)
        bottomButtonsStackView.addArrangedSubview(orderButton)
        
        accountButton.setTitle("Account", for: .normal)
        accountButton.titleLabel?.font = UIFont.mediumLargeThemeButtonFont
        
        eventsButton.setTitle("Events", for: .normal)
        eventsButton.titleLabel?.font = UIFont.mediumLargeThemeButtonFont
        
        homeButton.setTitle("Home", for: .normal)
        homeButton.titleLabel?.font = UIFont.mediumLargeThemeButtonFont
        
        orderButton.setTitle("Order", for: .normal)
        orderButton.titleLabel?.font = UIFont.mediumLargeThemeButtonFont
        
        NSLayoutConstraint.activate([
            bottomButtonsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bottomButtonsStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            bottomButtonsStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95),
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        accountButton.addTarget(self, action: #selector(launchAccountViewController), for: .touchUpInside)
        orderButton.addTarget(self, action: #selector(launchCheckoutViewController), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(launchHomePageViewController), for: .touchUpInside)
        if CheckoutCart.shared.user == nil {
            bottomButtonsStackView.isHidden = true
        }
        else {
            bottomButtonsStackView.isHidden = false
        }
    }
    override func updateConstraints() {
        if(shouldSetupConstraints) {
            // AutoLayout constraints
            shouldSetupConstraints = false
        }
        super.updateConstraints()

    }
    
    @objc func launchAccountViewController () {
        navigationController.pushViewController(AccountViewController(), animated: true)
    }
    @objc func launchCheckoutViewController () {
        navigationController.pushViewController(CheckoutViewController(), animated: true)
    }
    
    @objc func launchHomePageViewController () {
        rootViewController.switchToHomePageViewController()
    }
}
