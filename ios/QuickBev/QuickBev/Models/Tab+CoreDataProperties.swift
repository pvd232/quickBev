//
//  Tab+CoreDataProperties.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/4/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//

import CoreData
import Foundation

public extension Tab {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Tab> {
        return NSFetchRequest<Tab>(entityName: "Tab")
    }

    @NSManaged var id: UUID?
    @NSManaged var name: String?
    @NSManaged var businessId: UUID?
    @NSManaged var userId: String?
    @NSManaged var address: String?
    @NSManaged var dateTime: Date?
    @NSManaged var detail: String?
    @NSManaged var minimumContribution: Int64
    @NSManaged var fundraisingGoal: Int64
    @NSManaged var tabToUser: User?
}

extension Tab: Identifiable {}
