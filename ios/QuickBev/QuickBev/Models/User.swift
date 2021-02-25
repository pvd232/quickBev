//
//  User.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/1/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import CoreData

public class User: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case email = "id"
        case password = "password"
        case firstName = "first_name"
        case lastName = "last_name"
        case stripeId = "stripe_id"
        case emailVerified = "email_verified"
    }
    required public convenience init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.email = try container.decode(String.self, forKey: .email)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.password = try container.decode(String.self, forKey: .password)
        self.stripeId = try container.decode(String.self, forKey: .stripeId)
        self.emailVerified = try container.decode(Bool.self, forKey: .emailVerified)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.firstName, forKey: .firstName)
        try container.encode(self.lastName, forKey: .lastName)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.password, forKey: .email)
        try container.encode(self.stripeId, forKey: .email)
        try container.encode(self.password, forKey: .password)
        try container.encode(self.stripeId, forKey: .stripeId)
        try container.encode(self.emailVerified, forKey: .emailVerified)
    }
    var email: String {
        get {
            if let email = try! SecureStore(secureStoreQueryable: GenericPasswordQueryable()).getValue(for: self.firstName!)
            {
                return email
            }
            else {
                return ""
            }
        }
        set (newEmail) {
            try! SecureStore(secureStoreQueryable:GenericPasswordQueryable()).setValue(newEmail, for: self.firstName!)
        }
    }
    var password: String {
        get {
            if let password = try! SecureStore(secureStoreQueryable: GenericPasswordQueryable()).getValue(for: self.lastName!)
            {
                return password
            }
            else {
                return ""
            }
        }
        set (newPassword) {
            try! SecureStore(secureStoreQueryable:GenericPasswordQueryable()).setValue(newPassword, for: self.lastName!)
        }
    }
    var stripeId: String {
        get {
            if let stripeId = try! SecureStore(secureStoreQueryable: GenericPasswordQueryable()).getValue(for: self.firstName! + self.lastName!)
            {
                return stripeId
            }
            else {
                return ""
            }
        }
        set (newStripeId) {
            try! SecureStore(secureStoreQueryable:GenericPasswordQueryable()).setValue(newStripeId, for: self.firstName! + self.lastName!)
        }
    }
}
extension User {
    convenience init (FirstName: String, LastName:String, Email: String, Password: String, EmailVerified: Bool) {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        self.email = Email
        self.password = Password
        self.firstName = FirstName
        self.lastName = LastName
        self.emailVerified = EmailVerified
    }
    convenience init (FirstName: String, LastName:String, Email: String, Password: String, StripeId: String, EmailVerified: Bool) {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        self.firstName = FirstName
        self.lastName = LastName
        self.email = Email
        self.password = Password
        self.stripeId = StripeId
        self.emailVerified = EmailVerified
    }
}
