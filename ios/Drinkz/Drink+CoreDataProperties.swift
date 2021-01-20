//
//  Drink+CoreDataProperties.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/5/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//

import Foundation
import CoreData


extension Drink {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drink> {
        return NSFetchRequest<Drink>(entityName: "Drink")
    }
    
    @NSManaged public var barId: String?
    @NSManaged public var detail: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var quantity: Int16
    @NSManaged public var bar: Bar?
    @NSManaged public var relationship: CheckoutCart?
    @NSManaged public var drinkToOrder: Order?
    
}

extension Drink : Identifiable {
    
}
