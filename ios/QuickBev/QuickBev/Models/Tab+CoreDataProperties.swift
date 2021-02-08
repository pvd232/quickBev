//
//  Tab+CoreDataProperties.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/4/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//

import Foundation
import CoreData


extension Tab {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tab> {
        return NSFetchRequest<Tab>(entityName: "Tab")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var businessId: UUID?
    @NSManaged public var userId: String?
    @NSManaged public var address: String?
    @NSManaged public var dateTime: Date?
    @NSManaged public var detail: String?
    @NSManaged public var minimumContribution: Int64
    @NSManaged public var fundraisingGoal: Int64
    @NSManaged public var tabToUser: User?
    
}

extension Tab : Identifiable {
    
}
