//
//  ETag+CoreDataProperties.swift
//  QuickBev
//
//  Created by Peter Vail Driscoll II on 2/22/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//

import Foundation
import CoreData

extension ETag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ETag> {
        return NSFetchRequest<ETag>(entityName: "ETag")
    }

    @NSManaged public var id: Int64
    @NSManaged public var category: String?


}

extension ETag : Identifiable {

}
