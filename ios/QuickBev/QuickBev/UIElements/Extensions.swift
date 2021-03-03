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
        self = capitalizingFirstLetter()
    }
}

extension UIColor {
    class var themeColor: UIColor {
        return UIColor(red: 134 / 255, green: 130 / 255, blue: 230 / 255, alpha: 1.0)
    }

    class var greyBorderColor: UIColor {
        return UIColor(red: 204.0 / 255.0, green: 204.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
    }
}

extension NSLayoutConstraint {
    func usingPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

// this function allows you to plug in the current static font size you are using and replace it with a dynamic font size that scales with the phone's area based on the desired font size to area ratio tested on font size 20 with an iphone 11 pro max
public func calculateFontRatio(fontSize: CGFloat) -> CGFloat {
    let currentRatio = (UIViewController.screenSize.width * UIViewController.screenSize.height) / fontSize
    // desired ratio is based on Iphone 11 Pro Max with height of 896 and width of 414
    let desiredRatio = (414.0 * 896.0) / fontSize
    let differenceInRatios = desiredRatio / currentRatio
    let newFontSize = fontSize * differenceInRatios
    return newFontSize
}

extension UIFont {
    class var largeThemeLabelFont: UIFont {
        return UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 35.3))!
    }

    class var themeButtonFont: UIFont {
        return UIFont(name: "Charter-Black", size: calculateFontRatio(fontSize: 20.0))!
    }

    class var mediumLargeThemeButtonFont: UIFont {
        return UIFont(name: "Charter-Black", size: calculateFontRatio(fontSize: 18.0))!
    }

    class var mediumThemeButtonFont: UIFont {
        return UIFont(name: "Charter-Black", size: calculateFontRatio(fontSize: 16.0))!
    }

    class var smallThemeButtonFont: UIFont {
        return UIFont(name: "Charter-Black", size: calculateFontRatio(fontSize: 12.0))!
    }

    class var themeLabelFont: UIFont {
        return UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 20.0))!
    }

    class var themeLabelSmallFont: UIFont {
        return UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 14.0))!
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

extension UIViewController {
    class var screenSize: CGRect { return UIScreen.main.bounds }
}

extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

extension UIImageView {
    class var LogoImageView: UIImageView {
        return UIImageView(image: UIImage(named: "charterRomanPurpleLogo-30"))
    }
}

extension Double {
    static var logoSizeMultiplier = 0.565217
}

extension UITextField {
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216)) // 1
        datePicker.datePickerMode = .date // 2
        datePicker.minimumDate = Date()
        // iOS 14 and above
        if #available(iOS 14, *) { // Added condition for iOS 14
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        inputView = datePicker // 3

        // Create a toolBar and assign it to inputAccessoryView

        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) // 4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // 5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) // 7
        toolBar.setItems([cancel, flexible, barButton], animated: false) // 8
        inputAccessoryView = toolBar // 9
    }

    @objc func tapCancel() {
        resignFirstResponder()
    }
}

extension UIView {
    convenience init(theme: Theme) {
        self.init()
        switch self {
        case let self as UIStackView:
            switch theme {
            case let .UIStackView(props):
                for prop in props {
                    switch prop {
                    case .vertical:
                        self.axis = .vertical
                    case .horizontal:
                        self.axis = .horizontal
                    case let .spacing(value):
                        self.spacing = CGFloat(value)
                    }
                }
            default:
                ()
            }
        case let self as RoundButton:

            switch theme {
            case let .RoundButton(props):
                for prop in props {
                    switch prop {
                    case .color:
                        let value = prop.rawValue as! UIColor
                        self.refreshColor(color: value)

                    case var .titleLabelFont(value):
                        if value == nil {
                            value = prop.rawValue as? UIFont
                        }
                        self.titleLabel?.font = value
                    case let .text(value):
                        self.refreshTitle(newTitle: value)
                    }
                }
            default:
                ()
            }
        case let self as UILabel:
            switch theme {
            case let .UILabel(props):
                for prop in props {
                    switch prop {
                    case let .font(value):
                        if value == nil {
                            self.font = prop.rawValue as? UIFont
                        } else {
                            self.font = value
                        }
                    case .center:
                        self.textAlignment = .center
                    case let .text(value):
                        self.text = value
                    case .textColor:
                        self.textColor = .black
                    }
                }
            default:
                ()
            }
        case let self as UITextView:
            switch theme {
            case let .UITextView(props):
                for prop in props {
                    switch prop {
                    case let .font(value):
                        if value == nil {
                            self.font = prop.rawValue as? UIFont
                        } else {
                            self.font = value
                        }
                    case let .backgroundColor(value):
                        self.backgroundColor = value
                    case .textColor:
                        self.textColor = .black
                    }
                }
            default:
                ()
            }
        case let self as UITextField:
            switch theme {
            case let .UITextField(props):
                for prop in props {
                    switch prop {
                    case let .font(value):
                        if value == nil {
                            self.font = prop.rawValue as? UIFont
                        } else {
                            self.font = value
                        }

                    case let .placeHolderText(value):
                        let attributedText = NSAttributedString(string: value, attributes: [NSAttributedString.Key.foregroundColor: UIColor.clear])
                        self.attributedPlaceholder = attributedText
                    case let .autocapitalizationType(value):
                        switch value {
                        case .none:
                            self.autocapitalizationType = .none
                        }
                    case let .borderStyle(value):
                        switch value {
                        case .roundedRect:
                            self.borderStyle = .roundedRect
                        }
                    case let .backgroundColor(value):
                        self.backgroundColor = value
                    }
                    self.textColor = .black
                }
            default:
                ()
            }
        case let self as RoundedUITextField:
            switch theme {
            case let .UITextField(props):
                for prop in props {
                    switch prop {
                    case let .font(value):
                        if value == nil {
                            self.font = prop.rawValue as? UIFont
                        } else {
                            self.font = value
                        }
                    case let .placeHolderText(value):
                        let text = NSAttributedString(string: value, attributes: [NSAttributedString.Key.foregroundColor: UIColor.clear])
                        self.attributedPlaceholder = text
                    case let .autocapitalizationType(value):
                        switch value {
                        case .none:
                            self.autocapitalizationType = .none
                        }
                    case let .borderStyle(value):
                        switch value {
                        case .roundedRect:
                            self.borderStyle = .roundedRect
                        }
                    case let .backgroundColor(value):
                        self.backgroundColor = value
                    }
                    self.textColor = .black
                }
            default:
                ()
            }
        default:
            print("")
        }
    }
}

extension UIView {
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)

        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        addSubview(border)
    }

    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        addSubview(border)
    }
}

// 11 pro height = 812 - optimal font size for sign up view is 30
// 11 width = 375, height = 736
// 8 width = 375, height = 667
