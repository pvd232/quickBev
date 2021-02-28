//
//  ETag+CoreDataProperties.swift
//  QuickBev
//
//  Created by Peter Vail Driscoll II on 2/22/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//

import CoreData
import Foundation

public extension ETag {
    @nonobjc class func fetchRequest() -> NSFetchRequest<ETag> {
        return NSFetchRequest<ETag>(entityName: "ETag")
    }

    @NSManaged var id: Int64
    @NSManaged var category: String?
}

extension ETag: Identifiable {}
