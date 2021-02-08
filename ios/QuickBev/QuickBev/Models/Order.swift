//
//  Order.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 4/16/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//
import Foundation
import CoreData

public class Order: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case user = "customer"
        case merchantStripeId = "merchant_stripe_id"
        case businessId = "business_id"
        case orderDrink = "order_drink"
        case dateTime = "date_time"
        case cost = "cost"
        case subtotal = "subtotal"
        case tipPercentage = "tip_percentage"
        case tipAmount = "tip_amount"
        case salesTax = "sales_tax"
        case salesTaxRate = "sales_tax_percentage"

    }
    required convenience public init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.merchantStripeId = try container.decode(String.self, forKey: .merchantStripeId)
        self.user = try container.decode(User.self, forKey: .user)
        self.businessId = try container.decode(UUID.self, forKey: .businessId)
        self.cost = try container.decode(Double.self, forKey: .cost)
        self.orderDrink = NSSet.init(array: try container.decode([Drink].self, forKey: .orderDrink))
        self.dateTime = try container.decode(Date.self, forKey: .dateTime)
        self.subtotal =  try container.decode(Double.self, forKey: .subtotal)
        self.tipPercentage = try container.decode(Double.self, forKey: .tipPercentage)
        self.tipAmount = try container.decode(Double.self, forKey: .tipAmount)
        self.salesTax =  try container.decode(Double.self, forKey: .salesTax)
        self.salesTaxRate = try container.decode(Double.self, forKey: .salesTaxRate)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.merchantStripeId, forKey: .merchantStripeId)
        try container.encode(self.user, forKey: .user)
        try container.encode(self.businessId, forKey: .businessId)
        try container.encode(self.orderDrinkArray, forKey: .orderDrink)
        try container.encode(self.dateTime!.timeIntervalSince1970, forKey: .dateTime)
        try container.encode(self.cost, forKey: .cost)
        try container.encode(self.subtotal, forKey: .subtotal)
        try container.encode(self.tipPercentage, forKey: .tipPercentage)
        try container.encode(self.tipAmount, forKey: .tipAmount)
        try container.encode(self.salesTax, forKey: .salesTax)
        try container.encode(self.salesTaxRate, forKey: .salesTaxRate)
    }
}
extension Order {
    public var orderDrinkArray: [Drink] {
        let set = orderDrink! as? Set<Drink> ?? []
        return set.sorted {
            $0.name! < $1.name!
        }
    }
    convenience init(checkoutCart: CheckoutCart) {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        self.id = UUID()
        self.merchantStripeId = checkoutCart.userBusiness!.merchantStripeId!
        self.user = checkoutCart.user!
        self.businessId = checkoutCart.businessId!
        self.orderDrink = NSSet.init(array:checkoutCart.cart)
        self.dateTime = Date()
//        self.cost = checkoutCart.cost
        self.cost = 0.0
        self.subtotal = 0.0
        self.salesTax = 0.0
//        self.subtotal = checkoutCart.subtotal
//        self.salesTax = checkoutCart.salesTax
        self.salesTaxRate = checkoutCart.userBusiness!.salesTaxRate
        self.tipPercentage = checkoutCart.tipPercentage
        self.tipAmount = 0.0
//        self.tipAmount = checkoutCart.tipAmount
        for drink in checkoutCart.cart{
            print("drink in order", drink)
        }
    }
}




