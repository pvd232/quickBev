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
extension NSLayoutConstraint {
    func usingPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
extension UIFont {
    class var themeButtonFont:UIFont {
        return UIFont.init(name: "Charter-Black", size: 20.0)!
    }
    class var mediumLargeThemeButtonFont:UIFont {
        return UIFont.init(name: "Charter-Black", size: 18.0)!
    }
    class var mediumThemeButtonFont:UIFont {
        return UIFont.init(name: "Charter-Black", size: 16.0)!
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
extension UIView {
    convenience init(theme: Theme, superview: UIView? = nil) {
        self.init()
        switch self {
        case let self as UIStackView :
            switch theme {
            case .UIStackView(let props):
                for prop in props{
                    switch prop{
                    case .vertical:
                        self.axis = .vertical
                    case .horizontal:
                        self.axis = .horizontal
                    case .spacing(let value):
                        self.spacing = CGFloat(value)
                    }
                }
            default:
                ()
            }
            print("constraints", constraints)
        case let self as RoundButton:
            
            switch theme {
            case .RoundButton(let props):
                for prop in props{
                    switch prop{
                    case .color:
                        let value = prop.rawValue as! UIColor
                        self.refreshColor(color: value)
                   
                    case .titleLabelFont(var value):
                        if value == nil {
                            value  =  prop.rawValue as? UIFont
                        }
                            self.titleLabel?.font = value
                    case .text(let value):
                        self.refreshTitle(newTitle: value)
                   
                    }
                }
            default:
                ()
            }
        case let self as UILabel:
            switch theme {
            case .UILabel(let props):
                for prop in props{
                    switch prop{
                    case .font(let value):
                        if value == nil {
                            self.font  =  prop.rawValue as? UIFont
                        }
                        else {
                            self.font = value
                        }
                    case .center:
                        self.textAlignment = .center
                    case .text(let value):
                        self.text = value
                    }
                }
            default:
                ()
            }
        case let self as UITextField:
            switch theme {
            case .UITextField(let props):
                for prop in props{
                    print(prop)
                    switch prop{
                    case .font(let value):
                        if value == nil {
                            self.font  =  prop.rawValue as? UIFont
                        }
                        else {
                            self.font = value
                        }
                
                    case .placeHolderText(let value):
                        self.placeholder = value
                    case .autocapitalizationType(let value):
                        switch value {
                        case .none:
                            self.autocapitalizationType = .none
                        }
                    case .borderStyle(let value):
                        switch value {
                        case .roundedRect:
                            self.borderStyle = .roundedRect
                        }
                    case .backgroundColor(let value):
                    self.backgroundColor = value
                    }
                }
            default:
                ()
            }
            
            
        default:
            print("")
        }
    }
}
// 11 width = 375, height = 736
// 8 width = 375, height = 667
