//
//  User+CoreDataProperties.swift
//  QuickBev
//
//  Created by Peter Vail Driscoll II on 2/12/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

//    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
//    @NSManaged public var password: String?
//    @NSManaged public var stripeId: String?
    @NSManaged public var emailVerified: Bool
    @NSManaged public var relationship: CheckoutCart?
    @NSManaged public var userToOrder: NSSet?
    @NSManaged public var userToTab: NSSet?

}

// MARK: Generated accessors for userToOrder
extension User {

    @objc(addUserToOrderObject:)
    @NSManaged public func addToUserToOrder(_ value: Order)

    @objc(removeUserToOrderObject:)
    @NSManaged public func removeFromUserToOrder(_ value: Order)

    @objc(addUserToOrder:)
    @NSManaged public func addToUserToOrder(_ values: NSSet)

    @objc(removeUserToOrder:)
    @NSManaged public func removeFromUserToOrder(_ values: NSSet)

}

// MARK: Generated accessors for userToTab
extension User {

    @objc(addUserToTabObject:)
    @NSManaged public func addToUserToTab(_ value: Tab)

    @objc(removeUserToTabObject:)
    @NSManaged public func removeFromUserToTab(_ value: Tab)

    @objc(addUserToTab:)
    @NSManaged public func addToUserToTab(_ values: NSSet)

    @objc(removeUserToTab:)
    @NSManaged public func removeFromUserToTab(_ values: NSSet)

}

extension User : Identifiable {

}
