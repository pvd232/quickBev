//
//  User+CoreDataProperties.swift
//  QuickBev
//
//  Created by Peter Vail Driscoll II on 2/12/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//

import CoreData
import Foundation

public extension User {
    @nonobjc class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

//    @NSManaged public var email: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
//    @NSManaged public var password: String?
//    @NSManaged public var stripeId: String?
    @NSManaged var emailVerified: Bool
    @NSManaged var relationship: CheckoutCart?
    @NSManaged var userToOrder: NSSet?
    @NSManaged var userToTab: NSSet?
}

// MARK: Generated accessors for userToOrder

public extension User {
    @objc(addUserToOrderObject:)
    @NSManaged func addToUserToOrder(_ value: Order)

    @objc(removeUserToOrderObject:)
    @NSManaged func removeFromUserToOrder(_ value: Order)

    @objc(addUserToOrder:)
    @NSManaged func addToUserToOrder(_ values: NSSet)

    @objc(removeUserToOrder:)
    @NSManaged func removeFromUserToOrder(_ values: NSSet)
}

// MARK: Generated accessors for userToTab

public extension User {
    @objc(addUserToTabObject:)
    @NSManaged func addToUserToTab(_ value: Tab)

    @objc(removeUserToTabObject:)
    @NSManaged func removeFromUserToTab(_ value: Tab)

    @objc(addUserToTab:)
    @NSManaged func addToUserToTab(_ values: NSSet)

    @objc(removeUserToTab:)
    @NSManaged func removeFromUserToTab(_ values: NSSet)
}

extension User: Identifiable {}
