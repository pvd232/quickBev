//
//  Tab.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 12/18/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import CoreData
import UIKit

public class Tab: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case tabResponse = "tab"
        case id
        case name
        case businessId = "business_id"
        case userId = "user_id"
        case address
        case dateTime = "date_time"
        case detail
        case minimumContribution = "minimum_contribution"
        case fundraisingGoal = "fundraising_goal"
    }

    public required convenience init(from decoder: Decoder) throws {
//        let context = CoreDataManager.sharedManager.persistentContainer.viewContext

        self.init(context: CoreDataManager.sharedManager.managedContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .tabResponse)
        id = try nestedContainer.decode(UUID.self, forKey: .id)
        name = try nestedContainer.decode(String.self, forKey: .name)
        businessId = try nestedContainer.decode(UUID.self, forKey: .businessId)
        userId = try nestedContainer.decode(String.self, forKey: .userId)
        address = try nestedContainer.decode(String.self, forKey: .address)
        dateTime = try nestedContainer.decode(Date.self, forKey: .dateTime)
        detail = try nestedContainer.decode(String.self, forKey: .detail)
        minimumContribution = try nestedContainer.decode(Int64.self, forKey: .minimumContribution)
        fundraisingGoal = try nestedContainer.decode(Int64.self, forKey: .fundraisingGoal)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var nestedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .tabResponse)
        try nestedContainer.encode(id, forKey: .id)
        try nestedContainer.encode(name!, forKey: .name)
        try nestedContainer.encode(businessId!, forKey: .businessId)
        try nestedContainer.encode(userId!, forKey: .userId)
        try nestedContainer.encode(address!, forKey: .address)
        try nestedContainer.encode(detail!, forKey: .detail)
        try nestedContainer.encode(dateTime!.timeIntervalSince1970, forKey: .dateTime)
        try nestedContainer.encode(minimumContribution, forKey: .minimumContribution)
        try nestedContainer.encode(fundraisingGoal, forKey: .fundraisingGoal)
    }
}

extension Tab {
    convenience init() {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        id = UUID()
        name = nil
        businessId = nil
        userId = nil
        address = nil
        dateTime = Date()
        detail = nil
        minimumContribution = 0
        fundraisingGoal = 0
    }

    convenience init(Name: String?, BusinessId: UUID?, UserId: String?, Address: String?, DateTime: Date, Detail: String?, MinimumContribution: Int64?, FundraisingGoal: Int64?) {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        id = UUID()
        name = Name
        businessId = BusinessId
        userId = UserId
        address = Address
        dateTime = DateTime
        detail = Detail
        minimumContribution = MinimumContribution!
        fundraisingGoal = FundraisingGoal!
    }
}
