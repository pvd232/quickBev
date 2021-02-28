//
//  AppDelegate.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 3/28/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import CoreData
import IQKeyboardManagerSwift
import Stripe
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        print("scene")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
            }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                // set the delegate in didFinishLaunchingWithOptions
                UNUserNotificationCenter.current().delegate = self
            }
        }
    }

//    @available(iOS 10.0, *)
//    func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void)
//    {
//        print("update")
//        // Handle the notification
//        completionHandler(
//            [UNNotificationPresentationOptions.alert,
//             UNNotificationPresentationOptions.sound,
//             UNNotificationPresentationOptions.badge])
//    }
    func applicationDidBecomeActive(_: UIApplication) {
        print("became active")
    }

    func application(_: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        StripeAPI.defaultPublishableKey = "pk_test_51I0xFxFseFjpsgWvepMo3sJRNB4CCbFPhkxj2gEKgHUhIGBnciTqNVzjz1wz68Btbd5zAb2KC9eXpYaiOwLDA5QH00SZhtKPLT"
        IQKeyboardManager.shared.enable = true
        registerForPushNotifications()
        print("launch")
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
            let navController: UINavigationController = SceneDelegate.shared.rootViewController.current as! UINavigationController

            navController.pushViewController(RegistrationWithEmailViewController(), animated: true)
        }
        return true
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("register device token")
        //        self.enableRemoteNotificationFeatures()
        //        CheckoutCart.beamsClient.registerDeviceToken(deviceToken)
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        try! SecureStore(secureStoreQueryable: GenericPasswordQueryable()).setValue(token, for: "deviceToken")
//        let userCredentials: [HTTPHeader] = [HTTPHeader(field: "Authorization: Bearer", value: token)]
//        let sendDeviceTokenRequest = try! APIRequest(method: .post, path: "/apn-token", headers: userCredentials)
//        APIClient().perform(sendDeviceTokenRequest) { result in
//            switch result {
//            case let .success(response):
//                if response.statusCode == 200 {
//                    print("token registered")
//                }
//            case let .failure(error):
//                print("error", error.localizedDescription)
//                print("Device Token: \(token)")
//            }
//        }
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

    func userNotificationCenter(_: UNUserNotificationCenter,
                                didReceive _: UNNotificationResponse,
                                withCompletionHandler _: @escaping () -> Void)
    {
        print("notification tapped here")
        switch UIApplication.shared.applicationState {
        case .active:
            print("active")
        // app is currently active, can update badges count here
        case .inactive:
            print("inactive")

        // app is transitioning from background to foreground (user taps notification), do what you need when user taps here
        case .background:
            print("background")

        // app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
        default:
            print("something else")
        }
    }

    func application(
        _: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void
    ) {
        let navController: UINavigationController = SceneDelegate.shared.rootViewController.current as! UINavigationController

        print("userInfo", userInfo)

        if let aps = userInfo["aps"] as? NSDictionary {
            // silent notification
            if aps["content-available"] as? Int == 1 {
            } else {
                if let alert = aps["alert"] as? NSDictionary {
                    if let body = alert["body"] as? NSString {
                        if let title = alert["title"] as? NSString {
                            print("alert")
                            let alertController = UIAlertController(title: title as String, message: body as String, preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "Okay", style: .cancel) { _ in
                                SceneDelegate.shared.rootViewController.dismiss(animated: true, completion: nil)
                            })
                            SceneDelegate.shared.rootViewController.current.present(alertController, animated: true, completion: nil)
                        }
                    }

                    // do something with silent notification
                } else if let _ = aps["alert"] as? NSString {
                    navController.pushViewController(RegistrationWithEmailViewController(), animated: true)
                    // Do stuff
                }
            }
            completionHandler(.newData)
            // do something with regular notification
        }
    }

    func applicationWillTerminate(_: UIApplication) {
        //        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        CoreDataManager.sharedManager.saveContext()
    }
}
