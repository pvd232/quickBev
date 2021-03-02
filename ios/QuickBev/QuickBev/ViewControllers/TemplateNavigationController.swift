//
//  TemplateNavigationController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/10/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
class TemplateNavigationController: UINavigationController {
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.standardAppearance.backgroundColor = UIColor.themeColor
        navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 25.0))!]
    }
}
