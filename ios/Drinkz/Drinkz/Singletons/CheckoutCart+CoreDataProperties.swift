//
//  CheckoutCart+CoreDataProperties.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 2/2/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//

import Foundation
import CoreData


extension CheckoutCart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckoutCart> {
        return NSFetchRequest<CheckoutCart>(entityName: "CheckoutCart")
    }

    @NSManaged public var businessId: UUID?
    @NSManaged public var cost: Double
    @NSManaged public var currentOrderId: UUID?
    @NSManaged public var orderingProcessViewControllerIndex: Int16
    @NSManaged public var salesTax: Double
    @NSManaged public var stripeId: String?
    @NSManaged public var subtotal: Double
    @NSManaged public var tipAmount: Double
    @NSManaged public var tipPercentage: Double
    @NSManaged public var userId: String?
    @NSManaged public var business: NSSet?
    @NSManaged public var drinks: NSSet?
    @NSManaged public var user: User?
    @NSManaged public var userBusiness: Business?
    @NSManaged public var isGuest: Bool

}

// MARK: Generated accessors for business
extension CheckoutCart {

    @objc(addBusinessObject:)
    @NSManaged public func addToBusiness(_ value: Business)

    @objc(removeBusinessObject:)
    @NSManaged public func removeFromBusiness(_ value: Business)

    @objc(addBusiness:)
    @NSManaged public func addToBusiness(_ values: NSSet)

    @objc(removeBusiness:)
    @NSManaged public func removeFromBusiness(_ values: NSSet)

}

// MARK: Generated accessors for drinks
extension CheckoutCart {

    @objc(addDrinksObject:)
    @NSManaged public func addToDrinks(_ value: Drink)

    @objc(removeDrinksObject:)
    @NSManaged public func removeFromDrinks(_ value: Drink)

    @objc(addDrinks:)
    @NSManaged public func addToDrinks(_ values: NSSet)

    @objc(removeDrinks:)
    @NSManaged public func removeFromDrinks(_ values: NSSet)

}

extension CheckoutCart : Identifiable {

}
