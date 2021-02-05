//
//  AppDelegate.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 3/28/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import CoreData
import Stripe
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        StripeAPI.defaultPublishableKey = "pk_test_51I0xFxFseFjpsgWvepMo3sJRNB4CCbFPhkxj2gEKgHUhIGBnciTqNVzjz1wz68Btbd5zAb2KC9eXpYaiOwLDA5QH00SZhtKPLT"
        IQKeyboardManager.shared.enable = true

        return true
    }
    // MARK: - Core Data stack
    
    func applicationWillTerminate(_ application: UIApplication) {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataManager.sharedManager.saveContext(context:managedContext)
    }
    
}

