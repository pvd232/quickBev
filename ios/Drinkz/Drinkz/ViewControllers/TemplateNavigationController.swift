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
        self.navigationBar.standardAppearance.backgroundColor = UIColor.init(red: 134/255, green: 130/255, blue: 230/255, alpha: 1.0)
    }
}
