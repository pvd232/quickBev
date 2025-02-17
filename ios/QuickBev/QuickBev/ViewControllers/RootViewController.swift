//
//  RootViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/9/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
import UIKit

class RootViewController: UIViewController {
    var current: UIViewController
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        if CheckoutCart.shared.userId != "", CheckoutCart.shared.user?.emailVerified == true {
            current = TemplateNavigationController(rootViewController: HomePageViewController())
        } else {
            current = TemplateNavigationController(rootViewController: SplashPageViewController())
        }
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
        if CheckoutCart.shared.user?.emailVerified == false {
            if let current = current as? UINavigationController {
                current.pushViewController(VerifyEmailViewController(), animated: false)
            }
        }
    }

    func switchToHomePageViewController() {
        let mainScreen = TemplateNavigationController(rootViewController: HomePageViewController())
        animateFadeTransition(to: mainScreen)
    }

    func switchToSplashPageViewController() {
        let splashPage = TemplateNavigationController(rootViewController: SplashPageViewController())
        animateFadeTransition(to: splashPage)
    }

    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParent: nil)
        addChild(new)

        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {}) { _ in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?() // 1
        }
    }
}
