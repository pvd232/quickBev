//
//  SceneDelegate.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 3/28/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import IQKeyboardManagerSwift
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    static var shared: SceneDelegate {
        return UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
    }

    var window: UIWindow?

    var rootViewController: RootViewController {
        return window!.rootViewController as! RootViewController
    }

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        // need to initialize checkout cart or shit gets fucked up
        _ = CheckoutCart.shared

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = RootViewController()
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_: UIScene) {
//        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        CoreDataManager.sharedManager.saveContext()
    }

    func changeRootViewController(_ vc: UIViewController, animated _: Bool = true) {
        guard let window = self.window else {
            return
        }

        // change the root view controller to your specific view controller
        window.rootViewController = vc
    }
}
