//
//  RoundedUITextView.swift
//  QuickBev
//
//  Created by Peter Vail Driscoll II on 2/18/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
class RoundedUITextField: UITextField {
    var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }

    var borderColor = UIColor.lightGray {
        didSet {
            refreshBorderColor(color: borderColor)
        }
    }

    var borderWidth: CGFloat = 0.75 {
        didSet {
            refreshBorderWidth(value: borderWidth)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    override func prepareForInterfaceBuilder() {
        sharedInit()
    }

    func sharedInit() {
        refreshCorners(value: cornerRadius)
        refreshBorderColor(color: borderColor)
        refreshBorderWidth(value: borderWidth)
    }

    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }

    func refreshBorderColor(color: UIColor) {
        layer.borderColor = color.cgColor
    }

    func refreshBorderWidth(value: CGFloat) {
        layer.borderWidth = value
    }
}
