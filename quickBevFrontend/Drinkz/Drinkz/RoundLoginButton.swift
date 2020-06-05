//
//  RoundLoginButton.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/1/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
//https://spin.atomicobject.com/2017/07/18/swift-interface-builder/
@IBDesignable class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    @IBInspectable var backgroundImageColor: UIColor = UIColor.white {
        didSet {
            refreshColor(color: backgroundImageColor)
        }
    }

    @IBInspectable
    var borderColor: UIColor = UIColor.lightGray {
        didSet {
            refreshBorderColor (color: borderColor)
        }}
    
    @IBInspectable
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
        refreshColor(color: backgroundImageColor)

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
    func createImage(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 0.0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    func refreshColor(color: UIColor) {
        let image = createImage(color: color)
        setBackgroundImage(image, for: .normal)
        clipsToBounds = true
    }
}
