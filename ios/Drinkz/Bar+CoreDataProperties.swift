//
//  Bar+CoreDataProperties.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/1/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//

import Foundation
import CoreData


extension Bar {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bar> {
        return NSFetchRequest<Bar>(entityName: "Bar")
    }
    
    @NSManaged public var address: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var drinks: NSSet?
    @NSManaged public var salesTaxRate: Double
    @NSManaged public var coordinateString: String?
    @NSManaged public var userBarToCheckoutCart: CheckoutCart?
    @NSManaged public var barsToCheckoutCart: CheckoutCart?
    
}

// MARK: Generated accessors for drinks
extension Bar {
    
    @objc(addDrinksObject:)
    @NSManaged public func addToDrinks(_ value: Drink)
    
    @objc(removeDrinksObject:)
    @NSManaged public func removeFromDrinks(_ value: Drink)
    
    @objc(addDrinks:)
    @NSManaged public func addToDrinks(_ values: NSSet)
    
    @objc(removeDrinks:)
    @NSManaged public func removeFromDrinks(_ values: NSSet)
    
}

extension Bar : Identifiable {
    
}
