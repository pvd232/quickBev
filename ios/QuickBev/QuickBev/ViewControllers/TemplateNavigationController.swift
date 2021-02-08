//
//  TemplateNavigationController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/10/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
class TemplateNavigationController: UINavigationController  {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.navigationBar.standardAppearance.backgroundColor = UIColor.themeColor
        self.navigationBar.standardAppearance.titleTextAttributes  = [NSAttributedString.Key.font: UIFont(name: "Charter-Roman", size: 25)!]
    }
}
