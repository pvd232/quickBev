//
//  Drink+CoreDataProperties.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/29/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//

import CoreData
import Foundation

public extension Drink {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Drink> {
        return NSFetchRequest<Drink>(entityName: "Drink")
    }

    @NSManaged var businessId: UUID?
    @NSManaged var detail: String?
    @NSManaged var id: UUID?
    @NSManaged var name: String?
    @NSManaged var price: Double
    @NSManaged var quantity: Int16
    @NSManaged var drinkToBusiness: Business?
    @NSManaged var drinkToOrder: Order?
    @NSManaged var drinkToCheckoutCart: CheckoutCart?
}

extension Drink: Identifiable {}
