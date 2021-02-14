//
//  VerifyEmailViewController.swift
//  QuickBev
//
//  Created by Peter Vail Driscoll II on 2/13/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import PusherSwift

class VerifyEmailViewController: UIViewController {
    @UsesAutoLayout var verificationStackView = UIStackView(theme: Theme.UIStackView(props: [.vertical, .spacing(10)]))
    @UsesAutoLayout var verifyEmailLabel =  UILabel(theme: Theme.UILabel(props: [.text("Your almost there!"), .font(nil), .textColor ]))
    @UsesAutoLayout var verifyEmailTextView =  UITextView()
    var pusher: Pusher!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder not set up")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(verificationStackView)
        verificationStackView.addSubview(verifyEmailLabel)
        verificationStackView.addSubview(verifyEmailTextView)
        
        verifyEmailTextView.font =     UIFont(name: "Charter-Roman", size: 14.0)
        verifyEmailTextView.textColor = .black
        verifyEmailTextView.text = "Verify your account with the confirmation email we sent you.After verification, you will be automatically logged into the app"
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([ verificationStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
                                      verificationStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
                                      verificationStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),])
    }
    private func listenForEmailVerificationStatus() {
        let channel = pusher.subscribe("email-verification-status")
        channel.bind(eventName: "account-status", callback: { (data: Any?) -> Void in
            if let data = data as? Data {
                let status = try? JSONDecoder().decode([String: Bool].self, from: data)
                if status?["status"] == true {
                    DispatchQueue.main.async {
                        SceneDelegate.shared.rootViewController.switchToHomePageViewController()
                    }
                }
            }
        })
        pusher.connect()
    }
}
