//
//  SignInSplashPageViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/8/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

//import UIKit
//
//class SignInSplashPageViewController: UIViewController {
//    @UsesAutoLayout var signInSplashView = UIView()
//    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        self.view.backgroundColor = .white
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("coder not set up")
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        signInSplashView = SignInOrSignUpView(frame: self.view.frame, props: SignInAndSignUpProps.UserAction( action: .signIn))
//        self.view.addSubview(signInSplashView)
//        
//        let safeArea = self.view.safeAreaLayoutGuide
//        NSLayoutConstraint.activate([signInSplashView.topAnchor.constraint(equalTo: safeArea.topAnchor),
//                                     signInSplashView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
//                                     signInSplashView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
//                                     signInSplashView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
//        ])
//    }
//}
