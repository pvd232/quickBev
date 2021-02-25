//
//  ETag.swift
//  QuickBev
//
//  Created by Peter Vail Driscoll II on 2/22/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import Foundation
import CoreData

@objc(ETag)
public class ETag: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case category = "category"
    }
    required convenience public init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int64.self, forKey: .id)
        self.category = try container.decode(String.self, forKey: .category)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.category, forKey: .category)
    }
    convenience init(Id: Int64, Category: String) {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        self.id  = Id
        self.category = Category
    }
}
