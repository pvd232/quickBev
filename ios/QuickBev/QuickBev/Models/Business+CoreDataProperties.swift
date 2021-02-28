//
//  Business+CoreDataProperties.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/29/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//

import CoreData
import Foundation

public extension Business {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Business> {
        return NSFetchRequest<Business>(entityName: "Business")
    }

    @NSManaged var address: String?
    @NSManaged var coordinateString: String?
    @NSManaged var id: UUID?
    @NSManaged var name: String?
    @NSManaged var salesTaxRate: Double
    @NSManaged var merchantStripeId: String?
    @NSManaged var businessToCheckoutCart: CheckoutCart?
    @NSManaged var businessId: UUID?
    @NSManaged var drinks: NSSet?
    @NSManaged var userBusinessToCheckoutCart: CheckoutCart?
}

// MARK: Generated accessors for drinks

public extension Business {
    @objc(addDrinksObject:)
    @NSManaged func addToDrinks(_ value: Drink)

    @objc(removeDrinksObject:)
    @NSManaged func removeFromDrinks(_ value: Drink)

    @objc(addDrinks:)
    @NSManaged func addToDrinks(_ values: NSSet)

    @objc(removeDrinks:)
    @NSManaged func removeFromDrinks(_ values: NSSet)
}

extension Business: Identifiable {}
