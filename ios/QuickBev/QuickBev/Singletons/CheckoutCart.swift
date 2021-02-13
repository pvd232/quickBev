import CoreData
import Stripe

public class CheckoutCart: NSManagedObject {
    private convenience init() {
        self.init(context: CoreDataManager.sharedManager.managedContext)
    }
    static var customerContext: STPCustomerContext = STPCustomerContext(keyProvider: StripeAPIClient.sharedAPIClient)
    static var shared:CheckoutCart {
        get {
            let fetchedResults = CoreDataManager.sharedManager.fetchEntities(entityName: "CheckoutCart")
            if fetchedResults!.count > 0 {
                return fetchedResults![0] as! CheckoutCart
            }
            else {
                return CheckoutCart()
            }
        }
    }
    static var guestDrink: Drink? = nil
}
extension CheckoutCart {
    public var cart: [Drink] {
        let set = drinks as? Set<Drink> ?? []
        return set.sorted {
            $0.name! < $1.name!
        }
    }
    public var businessArray: [Business] {
        let set = business as? Set<Business> ?? []
        return set.sorted {
            $0.name! < $1.name!
        }
    }
    public var userBusinessDrinks: [Drink] {
        let set = userBusiness!.drinks as? Set<Drink> ?? []
        return set.sorted {
            $0.name! < $1.name!
        }
    }
    public var canPay: Bool {
        return !cart.isEmpty
    }
    
    public func calculateCost () {
        self.subtotal = (cart.reduce(0) { (currentCheckoutCartTotal, drink) -> Double in
            return currentCheckoutCartTotal + drink.cost
        }).rounded(digits:2)
        self.salesTax = (self.cost * userBusiness!.salesTaxRate).rounded(digits:2)
        self.tipAmount = (self.tipPercentage * self.subtotal).rounded(digits: 2)
        self.cost = (self.subtotal + self.salesTax + self.tipAmount).rounded(digits: 2)
    }
    public func emptyCart () {
        self.cost = 0.0
        self.drinks = NSSet.init(array: [Drink]())
    }
}
