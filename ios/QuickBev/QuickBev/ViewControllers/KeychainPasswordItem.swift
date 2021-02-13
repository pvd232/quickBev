/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A struct for accessing generic password keychain items.
*/
 
import Foundation
 
struct KeychainPasswordItem {
    // MARK: Types
    
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError(status: OSStatus)
    }
    
    // MARK: Properties
    
    let service: String
    
    private(set) var account: String
    
    let accessGroup: String?
 
    // MARK: Intialization
    
    init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }
    
    // MARK: Keychain access
    
    func readPassword() throws -> String  {
        /*
            Build a query to find the item that matches the service, account and
            access group.
        */
        var query = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        // Parse the password string from the query result.
        guard let existingItem = queryResult as? [String : AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.unexpectedPasswordData
        }
        
        return password
    }
    
    func savePassword(_ password: String) throws {
        // Encode the password into an Data object.
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        
        do {
            // Check for an existing item in the keychain.
            try _ = readPassword()
 
            // Update the existing item with the new password.
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
 
            let query = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
        catch KeychainError.noPassword {
            /*
                No password was found in the keychain. Create a dictionary to save
                as a new keychain item.
            */
            var newItem = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }
    
    mutating func renameAccount(_ newAccountName: String) throws {
        // Try to update an existing item with the new account name.
        var attributesToUpdate = [String : AnyObject]()
        attributesToUpdate[kSecAttrAccount as String] = newAccountName as AnyObject?
        
        let query = KeychainPasswordItem.keychainQuery(withService: service, account: self.account, accessGroup: accessGroup)
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
        
        self.account = newAccountName
    }
    
    func deleteItem() throws {
        // Delete the existing item from the keychain.
        let query = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    static func passwordItems(forService service: String, accessGroup: String? = nil) throws -> [KeychainPasswordItem] {
        // Build a query for all items that match the service and access group.
        var query = KeychainPasswordItem.keychainQuery(withService: service, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanFalse
        
        // Fetch matching items from the keychain.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // If no items were found, return an empty array.
        guard status != errSecItemNotFound else { return [] }
 
        // Throw an error if an unexpected status was returned.
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        // Cast the query result to an array of dictionaries.
        guard let resultData = queryResult as? [[String : AnyObject]] else { throw KeychainError.unexpectedItemData }
        
        // Create a `KeychainPasswordItem` for each dictionary in the query result.
        var passwordItems = [KeychainPasswordItem]()
        for result in resultData {
            guard let account  = result[kSecAttrAccount as String] as? String else { throw KeychainError.unexpectedItemData }
            
            let passwordItem = KeychainPasswordItem(service: service, account: account, accessGroup: accessGroup)
            passwordItems.append(passwordItem)
        }
        
        return passwordItems
    }
 
    // MARK: Convenience
    
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String : AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
 
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
 
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
}
//class WebSocketIOClient {
//    private let manager: SocketManager
//    private var isConnected: Bool = false
//    var socket: SocketIOClient
//    
//    private init() {
//        manager = SocketManager(socketURL: URL(string: "http://127.0.0.1:5000")!, config: [.log(true), .compress, .reconnects(true)])
//        socket = manager.defaultSocket
//        socket.on(clientEvent: .connect) {data, ack in
//            print("socket connected")
//        }
//
//    }
//    public func connect() {
//        if !isConnected {
//            socket.connect()
//            isConnected = true
//        }
//    }
//    
//    public func disconnect() {
//        if isConnected {
//            socket.disconnect()
//            isConnected = false
//            manager.reconnects = false
//        }
//    }
//    
//    static let shared = WebSocketIOClient()
//    
//
//    
//}
//
//  RegistrationWithEmailViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/4/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

//import UIKit
//import SocketIO

//class RegistrationWithEmailViewController: UIViewController {
//    func onConnected(connection: WebSocketConnection) {
//        print("successful websocket connection")
//    }
//
//    func onDisconnected(connection: WebSocketConnection, error: Error?) {
//        print("web socket disconnected", error ?? "no error")
//    }
//
//    func onError(connection: WebSocketConnection, error: Error) {
//        print("web socket error", error)
//    }
//
//    func onMessage(connection: WebSocketConnection, text: String) {
//        print("string message received", text)
//    }
//
//    func onMessage(connection: WebSocketConnection, data: Data) {
//        print("data received", (try? JSONDecoder().decode(String.self, from: data)) ?? "couldnt decode message")
//    }

//    let socket = SocketManager(socketURL: URL(string: "http://localhost:5000")!, config: [.log(true), .compress]).defaultSocket

    
//    @UsesAutoLayout var firstNameTextField = UITextField(theme: Theme.UITextField(props: [ .font(nil), .placeHolderText("Your first name"), .autocapitalizationType(autocapitalizationType: .none), .borderStyle(borderStyle: .roundedRect), .backgroundColor(UIColor.clear)]))
//    @UsesAutoLayout var lastNameTextField = UITextField(theme: Theme.UITextField(props: [ .font(nil), .placeHolderText("Your last name"), .autocapitalizationType(autocapitalizationType: .none), .borderStyle(borderStyle: .roundedRect), .backgroundColor(UIColor.clear)]))
//    @UsesAutoLayout var emailTextField = UITextField(theme: Theme.UITextField(props: [ .font(nil), .placeHolderText("Your email adress"), .autocapitalizationType(autocapitalizationType: .none), .borderStyle(borderStyle: .roundedRect), .backgroundColor(UIColor.clear)]))
//    @UsesAutoLayout var passwordTextField = UITextField(theme: Theme.UITextField(props: [ .font(nil), .placeHolderText("Your password"), .autocapitalizationType(autocapitalizationType: .none), .borderStyle(borderStyle: .roundedRect), .backgroundColor(UIColor.clear)]))
//    @UsesAutoLayout var confirmPasswordTextField = UITextField(theme: Theme.UITextField(props: [ .font(nil), .placeHolderText("Confirm your password"), .autocapitalizationType(autocapitalizationType: .none), .borderStyle(borderStyle: .roundedRect), .backgroundColor(UIColor.clear)]))
//    @UsesAutoLayout var firstNameLabel = UILabel(theme: Theme.UILabel(props: [.text("First Name"), .font(nil), .textColor ]))
//    @UsesAutoLayout var lastNameLabel =  UILabel(theme: Theme.UILabel(props: [.text("Last Name"), .font(nil), .textColor]))
//    @UsesAutoLayout var emailLabel =  UILabel(theme: Theme.UILabel(props: [.text("Email"), .font(nil), .textColor ]))
//    @UsesAutoLayout var passwordLabel =  UILabel(theme: Theme.UILabel(props: [.text("Password"), .font(nil), .textColor ]))
//    @UsesAutoLayout var confirmPasswordLabel =  UILabel(theme: Theme.UILabel(props: [.text("Confirm Password"), .font(nil)]))
//    @UsesAutoLayout var registrationStackView = UIStackView(theme: Theme.UIStackView(props: [.vertical, .spacing(10)]))
//    @UsesAutoLayout var submitButton = RoundButton(theme: Theme.RoundButton(props: [ .color, .text("Submit"), .titleLabelFont(nil)]))
//    @UsesAutoLayout private var activityIndicator = UIActivityIndicatorView(style: .large)
//
////    var webSocketConnectionDelegate: WebSocketConnectionDelegate?
////    let webSocketTaskConnection = WebSocketTaskConnection(url: "ws")
//    init() {
//        super.init(nibName: nil, bundle: nil)
////        webSocketConnectionDelegate = self
//        self.view.backgroundColor = .white
//
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("coder not set up")
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.addSubview(registrationStackView)
//        self.view.addSubview(submitButton)
//        self.view.addSubview(activityIndicator)
//        activityIndicator.frame = view.bounds
//        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
//        registrationStackView.addArrangedSubview(firstNameLabel)
//        registrationStackView.addArrangedSubview(firstNameTextField)
//        registrationStackView.addArrangedSubview(lastNameLabel)
//        registrationStackView.addArrangedSubview(lastNameTextField)
//        registrationStackView.addArrangedSubview(emailLabel)
//        registrationStackView.addArrangedSubview(emailTextField)
//        registrationStackView.addArrangedSubview(passwordLabel)
//        registrationStackView.addArrangedSubview(passwordTextField)
//        registrationStackView.addArrangedSubview(confirmPasswordLabel)
//        registrationStackView.addArrangedSubview(confirmPasswordTextField)
//
//        let safeArea = self.view.safeAreaLayoutGuide
//
//        NSLayoutConstraint.activate([
//            activityIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
//            activityIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
//            activityIndicator.widthAnchor.constraint(equalTo: activityIndicator.superview!.widthAnchor),
//            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.superview!.heightAnchor),
//            submitButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10.0),
//            submitButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
//            submitButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
//            submitButton.widthAnchor.constraint(equalTo: submitButton.heightAnchor, multiplier: (197/25)),
//            submitButton.topAnchor.constraint(lessThanOrEqualTo: registrationStackView.bottomAnchor, constant: (UIViewController.screenSize.height * 0.31)),
//
//            firstNameTextField.widthAnchor.constraint(equalTo: firstNameTextField.heightAnchor, multiplier: (197/25)),
//            lastNameTextField.widthAnchor.constraint(equalTo: lastNameTextField.heightAnchor, multiplier: (197/25)),
//            emailTextField.widthAnchor.constraint(equalTo: emailTextField.heightAnchor, multiplier: (197/25)),
//            passwordTextField.widthAnchor.constraint(equalTo: passwordTextField.heightAnchor, multiplier: (197/25)),
//            confirmPasswordTextField.widthAnchor.constraint(equalTo: confirmPasswordTextField.heightAnchor, multiplier: (197/25)),
//
//            registrationStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
//            registrationStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
//            registrationStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 35),
//        ]
//        )
//        submitButton.addTarget(self, action: #selector(submitRegistration), for: .touchUpInside)
//
//        self.addSocketHandlers()
//        WebSocketIOClient.shared.connect()
//
//
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        WebSocketIOClient.shared.disconnect()
//    }
//    private func addSocketHandlers (){
//        WebSocketIOClient.shared.socket.on("my-event") {[weak self] data, ack in
//            guard let data = data as? [Data] else {
//                print("data not returned as [Data]")
//                return
//            }
//            guard let responseJson = try? JSONDecoder().decode([String: Bool].self, from: data[0]) else {
//                print("failed to convert data", data)
//                return
//            }
//            self?.handleStart(json: responseJson)
//            return
//        }
//    }
//    private func handleStart (json: [String: Bool]) {
//        if json["status"] == true{
//            print("success")
//        }
//    }
//    private func pingServer <Body: Encodable>(data: Body) {
////        let newUser = User(Email: "a", FirstName: "a", LastName: "a", Password: "a")
//        WebSocketIOClient.shared.socket.emit("my-event", try! JSONEncoder().encode(data))
//    }
//    @objc private func submitRegistration(_ sender: RoundButton) {
//        activityIndicator.startAnimating()
//        let requestedNewUser: User  = {
//            // regular registration process
//            if CheckoutCart.shared.isGuest == false {
//                print("checkout card stripeId is nil")
//                return  User(Email : emailTextField.text!, FirstName: firstNameTextField.text!,LastName: lastNameTextField.text!,Password: passwordTextField.text!)
//            }
//            // guest registration process because the stripe id was acquired at home page when a user did not yet exist
//            else {
//                return User(Email : emailTextField.text!, FirstName: firstNameTextField.text!,LastName: lastNameTextField.text!,Password: passwordTextField.text!, StripeId: CheckoutCart.shared.stripeId!)
//            }
//        }()
//        self.pingServer(data: requestedNewUser)
//
//        let request = try! APIRequest(method: .post, path:"/customer", body: requestedNewUser)
//        APIClient().perform(request) {result in
//            switch result {
//            case .success (let response):
//                if response.statusCode == 200, let response = try? response.decode(to: [String: String].self)  {
//                    let responseJson = response.body
//                    CheckoutCart.shared.user = requestedNewUser
//                    CheckoutCart.shared.userId = requestedNewUser.email
//
//                    // when changing UI based on asynchronous operation, or when updating core data need to wrap in dispatch queue because both are asynchronous ops themselves
//                    DispatchQueue.main.async
//                    {
//                        if CheckoutCart.shared.isGuest == false {
//                            // if the new user's stripe id is nill then this is the regular user creation process and a stripe id will be sent from the backend
//                            CheckoutCart.shared.stripeId = responseJson["stripe_id"]
//                            requestedNewUser.stripeId = responseJson["stripe_id"]
//                            self.alertAccountCreation()
//                        }
//                        // the user is creating an account without having ordered something prior as a guest. this is the typical process which redirects to the home page
//                        else {
//                            self.alertAccountCreationForGuest()
//                        }
//                        CoreDataManager.sharedManager.saveContext()
//                        SceneDelegate.shared.rootViewController.switchToHomePageViewController()
//                        self.activityIndicator.stopAnimating()
//                    }
//                }
//                else {
//                    let alertController = UIAlertController(title: "Username already exists", message: "Your username is taken. Please choose another", preferredStyle: .alert)
//                    alertController.addAction(UIAlertAction(title: "Try again", style: .cancel) { action in
//                        self.dismiss( animated: true)
//                    })
//                    DispatchQueue.main.async {
//                        self.activityIndicator.stopAnimating()
//                        self.present(alertController, animated: true, completion: nil)
//                    }
//                }
//            case .failure(let error):                    // if the API fails the enum API result will be of the type failure
//                let alertController = UIAlertController(title: "Network Error", message: "A network error has occured. Check your internet connection and if necessary, restart the app.", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Okay", style: .cancel) { action in
//                    self.dismiss( animated: true)
//                })
//                DispatchQueue.main.async {
//                    self.activityIndicator.stopAnimating()
//                    self.present(alertController, animated: true, completion: nil)
//                    print("error case .failure", error)
//                }
//            }
//        }
//    }
//
//    private func alertAccountCreationForGuest() {
//        return self.alert(
//            title: "",
//            message: "Welcome to QuickBev! You may now proceed with your order.",
//            alertType: "accountCreationGuest"
//        )
//    }
//    private func alertAccountCreation() {
//        return self.alert(
//            title: "",
//            message: "Welcome to QuickBev!",
//            alertType: "accountCreation"
//        )
//    }
//    private func alert(title: String, message: String, alertType: String) {
//        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        if alertType == "accountCreationGuest"{
//            alertCtrl.addAction(UIAlertAction(title: "Okay", style: .cancel) { action in
//                let drinkViewController =  self.storyboard!.instantiateViewController(identifier: "DrinkViewController") as! DrinkViewController
//                let homePageViewController =  self.storyboard!.instantiateViewController(identifier: "HomePageViewController") as! HomePageViewController
//                let drinkListTableViewController =  self.storyboard!.instantiateViewController(identifier: "DrinkListTableViewController") as! DrinkListTableViewController
//                let navigationController = self.navigationController!
//                navigationController.setViewControllers([drinkViewController, drinkListTableViewController, homePageViewController], animated: true)
//            })
//        }
//        else if alertType == "accountCreation" {
//            alertCtrl.addAction(UIAlertAction(title: "Okay", style: .cancel) { action in
//                SceneDelegate.shared.rootViewController.switchToHomePageViewController()
//            })
//        }
//        present(alertCtrl, animated: true, completion: nil)
//    }
//}
//
