//
//  Order+CoreDataProperties.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/29/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var businessId: UUID?
    @NSManaged public var cost: Double
    @NSManaged public var dateTime: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var salesTax: Double
    @NSManaged public var subtotal: Double
    @NSManaged public var tipAmount: Double
    @NSManaged public var tipPercentage: Double
    @NSManaged public var orderDrink: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for orderDrink
extension Order {

    @objc(addOrderDrinkObject:)
    @NSManaged public func addToOrderDrink(_ value: Drink)

    @objc(removeOrderDrinkObject:)
    @NSManaged public func removeFromOrderDrink(_ value: Drink)

    @objc(addOrderDrink:)
    @NSManaged public func addToOrderDrink(_ values: NSSet)

    @objc(removeOrderDrink:)
    @NSManaged public func removeFromOrderDrink(_ values: NSSet)

}

extension Order : Identifiable {

}
