//
//  Extensions.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 2/4/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
extension UIColor {
    class var themeColor:UIColor {
        return UIColor.init(red: 134/255, green: 130/255, blue: 230/255, alpha: 1.0)
    }
}
extension UIFont {
    class var themeButtonFont:UIFont {
        return UIFont.init(name: "Charter-Black", size: 20.0)!
    }
    class var smallThemeButtonFont:UIFont {
        return UIFont.init(name: "Charter-Black", size: 12.0)!
    }
    class var themeLabelFont:UIFont {
        return UIFont.init(name: "Charter-Roman", size: 20.0)!
    }
    class var themeLabelSmallFont:UIFont {
        return UIFont.init(name: "Charter-Roman", size: 14.0)!
    }
}
@propertyWrapper
public struct UsesAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}
extension NSLayoutConstraint {
    
    /// Returns the constraint sender with the passed priority.
    ///
    /// - Parameter priority: The priority to be set.
    /// - Returns: The sended constraint adjusted with the new priority.
    func usingPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
    
}
extension UIViewController{
    class var screenSize: CGRect { return UIScreen.main.bounds}
    
}
extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
extension UITextField {
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        datePicker.minimumDate = Date()
        // iOS 14 and above
        if #available(iOS 14, *) {// Added condition for iOS 14
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        self.inputView = datePicker //3
        
        // Create a toolBar and assign it to inputAccessoryView
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}
