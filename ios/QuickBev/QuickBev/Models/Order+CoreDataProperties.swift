//
//  Order+CoreDataProperties.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/29/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//

import CoreData
import Foundation

public extension Order {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged var businessId: UUID?
    @NSManaged var merchantStripeId: String?
    @NSManaged var cost: Double
    @NSManaged var dateTime: Date?
    @NSManaged var id: UUID?
    @NSManaged var salesTax: Double
    @NSManaged var salesTaxRate: Double
    @NSManaged var subtotal: Double
    @NSManaged var tipAmount: Double
    @NSManaged var tipPercentage: Double
    @NSManaged var orderDrink: NSSet?
    @NSManaged var user: User?
}

// MARK: Generated accessors for orderDrink

public extension Order {
    @objc(addOrderDrinkObject:)
    @NSManaged func addToOrderDrink(_ value: Drink)

    @objc(removeOrderDrinkObject:)
    @NSManaged func removeFromOrderDrink(_ value: Drink)

    @objc(addOrderDrink:)
    @NSManaged func addToOrderDrink(_ values: NSSet)

    @objc(removeOrderDrink:)
    @NSManaged func removeFromOrderDrink(_ values: NSSet)
}

extension Order: Identifiable {}
