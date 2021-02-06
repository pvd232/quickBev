//
//  Theme.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 2/5/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import Foundation
import UIKit
enum Theme {
    enum UIStackViewProps{
        case horizontal
        case vertical
        case spacing(Float)
    }
    enum RoundButtonProps {
        case color
        case titleLabelFont(UIFont?)
        case text(String)
        var rawValue: Any {
            switch self {
            case .color:
                return UIColor.themeColor
            // allows me to override the parameter with the default value because usuallly the font will be default
            case .titleLabelFont(nil):
                return UIFont.themeButtonFont
            default:return ""
            }
        }
        
    }
    enum UILabelProps{
        case font(UIFont?)
        case center
        case text(String)
        var rawValue: Any {
            switch self {
            case .font(nil):
                return UIFont.themeLabelFont
            default: return ""
            }
        }
    }
    enum UITextFieldProps{
        case font(UIFont?)
        case placeHolderText(String)
        enum Borderstyle {
            case roundedRect
        }
        case borderStyle(borderStyle: Borderstyle)

        enum AutocapitalizationType{
            case none
        }
        
        case autocapitalizationType(autocapitalizationType: AutocapitalizationType)
        
        case backgroundColor(UIColor)
        
        var rawValue: Any {
            switch self {
            case .font(nil):
                return UIFont.themeLabelFont
            default:return 0.0
            }
        }
    }
    case RoundButton(props: [RoundButtonProps])
    case UIStackView(props: [UIStackViewProps])
    case UILabel(props: [UILabelProps])
    case UITextField(props: [UITextFieldProps])
}
