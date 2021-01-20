//
//  Tab.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 12/18/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import CoreData

public class Tab: NSManagedObject,Codable {
    
    enum CodingKeys: String, CodingKey {
        case tabResponse = "tab"
        case id = "id"
        case name = "name"
        case barId = "bar_id"
        case userId = "user_id"
        case address = "address"
        case dateTime = "date_time"
        case detail = "detail"
        case minimumContribution = "minimum_contribution"
        case fundraisingGoal = "fundraising_goal"
    }
    required convenience public init(from decoder: Decoder) throws {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .tabResponse)
        self.id = try nestedContainer.decode(String.self, forKey: .id)
        self.name = try nestedContainer.decode(String.self, forKey: .name)
        self.barId = try nestedContainer.decode(String.self, forKey: .barId)
        self.userId = try nestedContainer.decode(String.self, forKey: .userId)
        self.address = try nestedContainer.decode(String.self, forKey: .address)
        self.dateTime = try nestedContainer.decode(Date.self, forKey: .dateTime)
        self.detail = try nestedContainer.decode(String.self, forKey: .detail)
        self.minimumContribution = try nestedContainer.decode(Int64.self, forKey: .minimumContribution)
        self.fundraisingGoal = try nestedContainer.decode(Int64.self, forKey: .fundraisingGoal)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var nestedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .tabResponse)
        try nestedContainer.encode(self.id, forKey: .id)
        try nestedContainer.encode(self.name!, forKey: .name)
        try nestedContainer.encode(self.barId!, forKey: .barId)
        try nestedContainer.encode(self.userId!, forKey: .userId)
        try nestedContainer.encode(self.address!, forKey: .address)
        try nestedContainer.encode(self.detail!, forKey: .detail)
        try nestedContainer.encode(self.dateTime!.timeIntervalSince1970, forKey: .dateTime)
        try nestedContainer.encode(self.minimumContribution, forKey: .minimumContribution)
        try nestedContainer.encode(self.fundraisingGoal, forKey: .fundraisingGoal)
    }
}
extension Tab {
    convenience init () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        self.init(context: context)
        self.id = UUID().uuidString
        self.name = nil
        self.barId = nil
        self.userId = nil
        self.address = nil
        self.dateTime = Date.init()
        self.detail = nil
        self.minimumContribution = 0
        self.fundraisingGoal = 0
    }
    convenience init (Name: String?, BarId: String?, UserId: String?, Address:String?, DateTime: Date, Detail: String?, MinimumContribution: Int64?, FundraisingGoal: Int64?) {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        self.init(context: context)
        self.id = UUID().uuidString
        self.name = Name
        self.barId = BarId
        self.userId = UserId
        self.address = Address
        self.dateTime = DateTime
        self.detail = Detail
        self.minimumContribution = MinimumContribution!
        self.fundraisingGoal = FundraisingGoal!
    }
}
