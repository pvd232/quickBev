//
//  RootViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/9/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
import UIKit
class RootViewController:  UIViewController {
    private var current: UIViewController
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    rootViewController.navigationBar.standardAppearance.backgroundColor = UIColor.init(red: 134/255, green: 130/255, blue: 230/255, alpha: 1.0)

    init() {
        if CheckoutCart.shared.userId != nil {
            current = UINavigationController(rootViewController: HomePageViewController())
        }
        else {
            current = UINavigationController(rootViewController: SplashPageViewController())
        }
        super.init(nibName: nil, bundle: nil)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(current)
        current.view.frame = self.view.bounds
        self.view.addSubview(current.view)
        current.didMove(toParent: self)
    }
    
    func switchToHomePage() {
        let mainScreen = UINavigationController(rootViewController: HomePageViewController())
        animateFadeTransition(to: mainScreen)
    }
    
    func showLoginScreen() {
        let new = UINavigationController(rootViewController: LoginViewController())
        addChild(new)
        new.view.frame = self.view.bounds
        self.view.addSubview(new.view)
        new.didMove(toParent: self)
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        current = new
    }
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParent: nil)
        addChild(new)
        
        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()  //1
        }
    }
//    private func makeServiceCall() {
//       if UserDefaults.standard.bool(forKey: “LOGGED_IN”) {
//          // navigate to protected page
//          AppDelegate.shared.rootViewController.switchToMainScreen()
//       } else {
//          // navigate to login screen
//          AppDelegate.shared.rootViewController.switchToLogout()
//       }
//    }
}
