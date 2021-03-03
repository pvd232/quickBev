//
//  SplashPageViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/3/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import Stripe
import UIKit

class SplashPageViewController: UIViewController {
    @UsesAutoLayout var splashView = UIView()

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
        splashView = SplashView(frame: view.frame)
        view.addSubview(splashView)
        print("screenSize.height", UIViewController.screenSize.height)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([splashView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                                     splashView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                                     splashView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                                     splashView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)])
    }
}
