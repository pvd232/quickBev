//
//  CheckoutCart+CoreDataProperties.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 2/2/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//

import CoreData
import Foundation

public extension CheckoutCart {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CheckoutCart> {
        return NSFetchRequest<CheckoutCart>(entityName: "CheckoutCart")
    }

    @NSManaged var businessId: UUID?
    @NSManaged var cost: Double
    @NSManaged var currentOrderId: UUID?
    @NSManaged var orderingProcessViewControllerIndex: Int16
    @NSManaged var salesTax: Double
    @NSManaged var stripeId: String?
    @NSManaged var subtotal: Double
    @NSManaged var tipAmount: Double
    @NSManaged var tipPercentage: Double
    @NSManaged var userId: String?
    @NSManaged var business: NSSet?
    @NSManaged var drinks: NSSet?
    @NSManaged var user: User?
    @NSManaged var userBusiness: Business?
    @NSManaged var isGuest: Bool
}

// MARK: Generated accessors for business

public extension CheckoutCart {
    @objc(addBusinessObject:)
    @NSManaged func addToBusiness(_ value: Business)

    @objc(removeBusinessObject:)
    @NSManaged func removeFromBusiness(_ value: Business)

    @objc(addBusiness:)
    @NSManaged func addToBusiness(_ values: NSSet)

    @objc(removeBusiness:)
    @NSManaged func removeFromBusiness(_ values: NSSet)
}

// MARK: Generated accessors for drinks

public extension CheckoutCart {
    @objc(addDrinksObject:)
    @NSManaged func addToDrinks(_ value: Drink)

    @objc(removeDrinksObject:)
    @NSManaged func removeFromDrinks(_ value: Drink)

    @objc(addDrinks:)
    @NSManaged func addToDrinks(_ values: NSSet)

    @objc(removeDrinks:)
    @NSManaged func removeFromDrinks(_ values: NSSet)
}

extension CheckoutCart: Identifiable {}
