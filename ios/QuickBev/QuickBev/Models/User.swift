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
        //        case userResponse = "user"
        case email = "id"
        case password = "password"
        case firstName = "first_name"
        case lastName = "last_name"
        case stripeId = "stripe_id"
    }
    required public convenience init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decode(String.self, forKey: .email)
        self.firstName = try container.decode(String.self, forKey: .firstName)
        self.lastName = try container.decode(String.self, forKey: .lastName)
        self.password = try container.decode(String.self, forKey: .password)
        self.stripeId = try container.decode(String.self, forKey: .stripeId)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.firstName, forKey: .firstName)
        try container.encode(self.lastName, forKey: .lastName)
        try container.encode(self.password, forKey: .password)
        try container.encode(self.stripeId, forKey: .stripeId)
    }
}
extension User {
    convenience init (Email: String, FirstName: String, LastName:String, Password: String, EmailVerified: Bool) {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        self.email = Email
        self.firstName = FirstName
        self.lastName = LastName
        self.password = Password
        self.emailVerified = EmailVerified
    }
    convenience init (Email: String, FirstName: String, LastName:String, Password: String, StripeId: String, EmailVerified: Bool) {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        self.email = Email
        self.firstName = FirstName
        self.lastName = LastName
        self.password = Password
        self.stripeId = StripeId
        self.emailVerified = EmailVerified
    }
}
