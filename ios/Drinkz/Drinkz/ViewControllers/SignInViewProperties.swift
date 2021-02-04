//
//  SignInViewProperties.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 2/3/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

enum SignInAndSignUpProps {
    enum Action{
        case signIn
        case signUp
    }
    enum ActionProvider{
        case fb
        case google
        case quickBev
    }
    case UserAction(action: Action)
    func getButtonText(actionProvider: ActionProvider) -> String {
        switch self {
        case let .UserAction(action):
            switch action {
            case Action.signIn:
                switch actionProvider {
                case ActionProvider.fb:
                    return ("Sign in with Facebook")
                    
                case ActionProvider.google:
                    return ("Sign in with Google")
                case ActionProvider.quickBev:
                    return ("Sign in with email")

                }
            case Action.signUp:
                switch actionProvider {
                case ActionProvider.fb:
                    return ("Sign up with Facebook")
                    
                case ActionProvider.google:
                    return ("Sign up with Google")
                case ActionProvider.quickBev:
                    return ("Sign up with email")

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

            }

        }
        
    }
    func launchNewViewController (actionProvider: ActionProvider, splash: Bool) {
        switch self {
        case let .UserAction(action):
            switch action {
            case Action.signIn:
                switch actionProvider {
                case ActionProvider.fb:
                    SceneDelegate.shared.rootViewController.current.navigationController?.pushViewController(LoginViewController(), animated: true)

                case ActionProvider.google:
                    SceneDelegate.shared.rootViewController.current.navigationController?.pushViewController(LoginViewController(), animated: true)

                case ActionProvider.quickBev:
                    if splash == true{
                        SceneDelegate.shared.rootViewController.current.navigationController?.pushViewController(SignInSplashPageViewController(), animated: true)
                    }
                    else{
                        SceneDelegate.shared.rootViewController.current.navigationController?.pushViewController(LoginViewController(), animated: true)
                    }


                }
            case Action.signUp:
                switch actionProvider {
                case ActionProvider.fb:
                    SceneDelegate.shared.rootViewController.current.navigationController?.pushViewController(LoginViewController(), animated: true)
                    
                case ActionProvider.google:
                    SceneDelegate.shared.rootViewController.current.navigationController?.pushViewController(LoginViewController(), animated: true)

                case ActionProvider.quickBev:
                    if splash == true{
                        SceneDelegate.shared.rootViewController.current.navigationController?.pushViewController(RegistrationSplashPageViewController(), animated: true)
                    }
                    else {
                        SceneDelegate.shared.rootViewController.current.navigationController?.pushViewController(RegistrationWithEmailViewController(), animated: true)
                    }


                }
            }
        }
    }
}
