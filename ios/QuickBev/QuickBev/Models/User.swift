//
//  User.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/1/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import CoreData
import UIKit

public class User: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case email = "id"
        case password
        case firstName = "first_name"
        case lastName = "last_name"
        case stripeId = "stripe_id"
        case emailVerified = "email_verified"
    }

    public required convenience init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        email = try container.decode(String.self, forKey: .email)
        password = try container.decode(String.self, forKey: .password)
        stripeId = try container.decode(String.self, forKey: .stripeId)
        emailVerified = try container.decode(Bool.self, forKey: .emailVerified)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(stripeId, forKey: .stripeId)
        try container.encode(emailVerified, forKey: .emailVerified)
    }

    var email: String {
        get {
            if let email = try! SecureStore(secureStoreQueryable: GenericPasswordQueryable()).getValue(for: firstName!)
            {
                return email
            } else {
                return ""
            }
        }
        set(newEmail) {
            try! SecureStore(secureStoreQueryable: GenericPasswordQueryable()).setValue(newEmail, for: firstName!)
        }
    }

    var password: String {
        get {
            if let password = try! SecureStore(secureStoreQueryable: GenericPasswordQueryable()).getValue(for: lastName!)
            {
                print("made password", password)
                return password
            } else {
                print("no password")
                return ""
            }
        }
        set(newPassword) {
            try! SecureStore(secureStoreQueryable: GenericPasswordQueryable()).setValue(newPassword, for: lastName!)
        }
    }

    var stripeId: String {
        get {
            if let stripeId = try! SecureStore(secureStoreQueryable: GenericPasswordQueryable()).getValue(for: firstName! + lastName!)
            {
                return stripeId
            } else {
                return ""
            }
        }
        set(newStripeId) {
            try! SecureStore(secureStoreQueryable: GenericPasswordQueryable()).setValue(newStripeId, for: firstName! + lastName!)
        }
    }
}

extension User {
    // because email, password, and stripe id are computed properties that rely on first name and last name it is important we set them after first and last name
    convenience init(FirstName: String, LastName: String, Email: String, Password: String, EmailVerified: Bool) {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        firstName = FirstName
        lastName = LastName
        email = Email
        password = Password
        emailVerified = EmailVerified
    }

    convenience init(FirstName: String, LastName: String, Email: String, Password: String, StripeId: String, EmailVerified: Bool) {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        firstName = FirstName
        lastName = LastName
        email = Email
        password = Password
        stripeId = StripeId
        emailVerified = EmailVerified
    }
}
