//
//  SignInViewProperties.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 2/3/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
import UIKit
enum SignInAndSignUpProps {
    // this is an enumeration raw value. it returns a pre-specified value associated with the given case. as opposed to a user-defined associated value which would be passed in as a parameter to the enumeration case and be generated as a variable
    enum Action: String{
        case signIn
        case signUp
        case splash
    }
    enum ButtonIndex{
        case first
        case second
        case third
    }
    case UserAction(action: Action)
    func getButtonText(buttonIndex: ButtonIndex) -> String {
        switch self {
        case let .UserAction(action):
            switch action {
            case Action.signIn:
                switch buttonIndex {
                case .first:
                    return ("Sign in with Facebook")
                    
                case .second:
                    return ("Sign in with Google")
                case .third:
                    return ("Sign in with email")
                    
                }
            case Action.signUp:
                switch buttonIndex {
                case .first:
                    return ("Sign up with Facebook")
                    
                case .second:
                    return ("Sign up with Google")
                case .third:
                    return ("Sign up with email")
                    
                }
            case Action.splash:
                switch buttonIndex {
                case .first:
                    return ("Sign in to QuickBev")
                case .second:
                    return ("Create a QuickBev account")
                case .third:
                    return ("Continue as a guest")
                    
                }
            }
        }
    }
    func getCenterTitleText () -> String {
        switch self {
        case let .UserAction(action):
            switch action {
            case Action.signIn :
                return ("Sign in to QuickBev")
            case Action.signUp:
                return ("Sign up with QuickBev")
            case Action.splash:
                return ("Lets get started")
            }
            
        }
        
    }
    func getRawValue () -> String {
        switch self {
        case let .UserAction(action):
            return action.rawValue
        }
    }
    func launchNewViewController (buttonIndex: ButtonIndex) {
        let navController =  SceneDelegate.shared.rootViewController.current as! UINavigationController
        switch self {
        case let .UserAction(action):
            switch action {
            case Action.signIn:
                switch buttonIndex {
                case .first:
                    // fb sign up process
                    return
                case .second:
                    // google sign up process
                    return
                    
                case .third:
                    navController.pushViewController(LoginViewController(), animated: true)
                }
            case Action.signUp:
                switch buttonIndex {
                case .first:
                    // fb sign up process
                    return
                case .second:
                    // google sign up process
                    return
                case .third:
                    navController.pushViewController(RegistrationWithEmailViewController(), animated: true)
                }
            case Action.splash:
                switch buttonIndex {
                case .first:
                    navController.pushViewController(SignInSplashPageViewController(), animated: true)
                    
                case .second:
                    navController.pushViewController(RegistrationSplashPageViewController(), animated: true)
                    
                case .third:
                    navController.pushViewController(HomePageViewController(), animated: true)
                }
            }
        }
    }
}
