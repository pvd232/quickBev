//
//  Business+CoreDataProperties.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/29/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//

import Foundation
import CoreData


extension Business {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Business> {
        return NSFetchRequest<Business>(entityName: "Business")
    }

    @NSManaged public var address: String?
    @NSManaged public var coordinateString: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var salesTaxRate: Double
    @NSManaged public var stripeId: String?
    @NSManaged public var businessToCheckoutCart: CheckoutCart?
    @NSManaged public var businessAddressId: UUID?
    @NSManaged public var drinks: NSSet?
    @NSManaged public var userBusinessToCheckoutCart: CheckoutCart?

}

// MARK: Generated accessors for drinks
extension Business {

    @objc(addDrinksObject:)
    @NSManaged public func addToDrinks(_ value: Drink)

    @objc(removeDrinksObject:)
    @NSManaged public func removeFromDrinks(_ value: Drink)

    @objc(addDrinks:)
    @NSManaged public func addToDrinks(_ values: NSSet)

    @objc(removeDrinks:)
    @NSManaged public func removeFromDrinks(_ values: NSSet)

}

extension Business : Identifiable {

}
