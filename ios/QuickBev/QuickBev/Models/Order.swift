//
//  Order.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 4/16/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//
import CoreData
import Foundation

public class Order: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case user = "customer"
        case merchantStripeId = "merchant_stripe_id"
        case businessId = "business_id"
        case orderDrink = "order_drink"
        case dateTime = "date_time"
        case cost
        case subtotal
        case tipPercentage = "tip_percentage"
        case tipAmount = "tip_amount"
        case salesTax = "sales_tax"
        case salesTaxRate = "sales_tax_percentage"
    }

    public required convenience init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.sharedManager.managedContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        merchantStripeId = try container.decode(String.self, forKey: .merchantStripeId)
        user = try container.decode(User.self, forKey: .user)
        businessId = try container.decode(UUID.self, forKey: .businessId)
        cost = try container.decode(Double.self, forKey: .cost)
        orderDrink = NSSet(array: try container.decode([Drink].self, forKey: .orderDrink))
        dateTime = try container.decode(Date.self, forKey: .dateTime)
        subtotal = try container.decode(Double.self, forKey: .subtotal)
        tipPercentage = try container.decode(Double.self, forKey: .tipPercentage)
        tipAmount = try container.decode(Double.self, forKey: .tipAmount)
        salesTax = try container.decode(Double.self, forKey: .salesTax)
        salesTaxRate = try container.decode(Double.self, forKey: .salesTaxRate)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(merchantStripeId, forKey: .merchantStripeId)
        try container.encode(user, forKey: .user)
        try container.encode(businessId, forKey: .businessId)
        try container.encode(orderDrinkArray, forKey: .orderDrink)
        try container.encode(dateTime!.timeIntervalSince1970, forKey: .dateTime)
        try container.encode(cost, forKey: .cost)
        try container.encode(subtotal, forKey: .subtotal)
        try container.encode(tipPercentage, forKey: .tipPercentage)
        try container.encode(tipAmount, forKey: .tipAmount)
        try container.encode(salesTax, forKey: .salesTax)
        try container.encode(salesTaxRate, forKey: .salesTaxRate)
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
        id = UUID()
        merchantStripeId = checkoutCart.userBusiness!.merchantStripeId!
        user = checkoutCart.user!
        businessId = checkoutCart.businessId!
        orderDrink = NSSet(array: checkoutCart.cart)
        dateTime = Date()
        cost = 0.0
        subtotal = 0.0
        salesTax = 0.0
        salesTaxRate = checkoutCart.userBusiness!.salesTaxRate
        tipPercentage = checkoutCart.tipPercentage
        tipAmount = 0.0
    }
}
