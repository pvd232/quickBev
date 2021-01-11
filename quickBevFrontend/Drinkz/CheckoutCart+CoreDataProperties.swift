//
//  CheckoutCart+CoreDataProperties.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/1/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//

import Foundation
import CoreData


extension CheckoutCart {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckoutCart> {
        return NSFetchRequest<CheckoutCart>(entityName: "CheckoutCart")
    }
    
    @NSManaged public var barId: String?
    @NSManaged public var cost: Double
    @NSManaged public var subtotal: Double
    @NSManaged public var tipPercentage: Double
    @NSManaged public var tipAmount: Double
    @NSManaged public var userId: String?
    @NSManaged public var stripeId: String?
    @NSManaged public var salesTax: Double
    @NSManaged public var orderingProcessViewControllerIndex: Double
    @NSManaged public var bars: NSSet?
    @NSManaged public var drinks: NSSet?
    @NSManaged public var user: User?
    @NSManaged public var userBar: Bar?
    
}

// MARK: Generated accessors for bars
extension CheckoutCart {
    
    @objc(addBarsObject:)
    @NSManaged public func addToBars(_ value: Bar)
    
    @objc(removeBarsObject:)
    @NSManaged public func removeFromBars(_ value: Bar)
    
    @objc(addBars:)
    @NSManaged public func addToBars(_ values: NSSet)
    
    @objc(removeBars:)
    @NSManaged public func removeFromBars(_ values: NSSet)
    
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
