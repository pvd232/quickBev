import CoreData
import Foundation
import Stripe
public class CheckoutCart: NSManagedObject {
    private convenience init() {
        self.init(context: CoreDataManager.sharedManager.managedContext)
    }

    static var customerContext = STPCustomerContext(keyProvider: StripeAPIClient.sharedAPIClient)
    static var shared: CheckoutCart {
        let fetchedResults = CoreDataManager.sharedManager.fetchEntities(entityName: "CheckoutCart")
        if fetchedResults!.count > 0 {
            return fetchedResults![0] as! CheckoutCart
        } else {
            return CheckoutCart()
        }
    }

    static var guestDrink: Drink?

    static var businessETag: ETag? {
        get {
            var fetchedBool = false
            if let fetchedResults = CoreDataManager.sharedManager.fetchEntities(entityName: "ETag") as? [ETag], fetchedResults.count > 0 {
                for fetchedResult in fetchedResults {
                    if fetchedResult.category == "business" {
                        fetchedBool = true
                        return fetchedResult
                    }
                }
            }
            if fetchedBool == false {
                let newBusinessEtag = ETag(Id: -1, Category: "business")
                CoreDataManager.sharedManager.saveContext()
                return newBusinessEtag
            }
        }
        set {}
    }

    static var drinkETag: ETag? {
        get {
            var fetchedBool = false
            if let fetchedResults = CoreDataManager.sharedManager.fetchEntities(entityName: "ETag") as? [ETag], fetchedResults.count > 0 {
                for fetchedResult in fetchedResults {
                    if fetchedResult.category == "drink" {
                        fetchedBool = true
                        return fetchedResult
                    }
                }
            }
            if fetchedBool == false {
                let newDrinkEtag = ETag(Id: -1, Category: "drink")
                CoreDataManager.sharedManager.saveContext()
                return newDrinkEtag
            }
        }
        set {}
    }
}

public extension CheckoutCart {
    var cart: [Drink] {
        let set = drinks as? Set<Drink> ?? []
        return set.sorted {
            $0.name! < $1.name!
        }
    }

    var businessArray: [Business] {
        let set = business as? Set<Business> ?? []
        return set.sorted {
            $0.name! < $1.name!
        }
    }

    var userBusinessDrinks: [Drink] {
        let set = userBusiness!.drinks as? Set<Drink> ?? []
        return set.sorted {
            $0.name! < $1.name!
        }
    }

    var canPay: Bool {
        return !cart.isEmpty
    }

    func calculateCost() {
        subtotal = (cart.reduce(0) { (currentCheckoutCartTotal, drink) -> Double in
            currentCheckoutCartTotal + drink.cost
        }).rounded(digits: 2)
        if canPay {
            salesTax = (cost * userBusiness!.salesTaxRate).rounded(digits: 2)
            tipAmount = (tipPercentage * subtotal).rounded(digits: 2)
            cost = (subtotal + salesTax + tipAmount).rounded(digits: 2)
        }
    }

    func emptyCart() {
        cost = 0.0
        drinks = NSSet(array: [Drink]())
    }
}
