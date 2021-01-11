import CoreData
import Stripe

public class CheckoutCart: NSManagedObject {
    private convenience init() {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        self.init(context: context)
    }
    static let customerContext: STPCustomerContext = STPCustomerContext(keyProvider: StripeAPIClient.sharedAPIClient)
    static var shared:CheckoutCart {
        get {
            let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
            let fetchedResults = CoreDataManager.sharedManager.fetchEntities(entityName: "CheckoutCart", context: managedContext)
            if fetchedResults!.count > 0 {
                return fetchedResults![0] as! CheckoutCart
            }
            else {
                return CheckoutCart()
            }
        }
    }
}
extension CheckoutCart {
    public var cart: [Drink] {
        let set = drinks as? Set<Drink> ?? []
        return set.sorted {
            $0.name! < $1.name!
        }
    }
    public var barArray: [Bar] {
        let set = bars as? Set<Bar> ?? []
        return set.sorted {
            $0.name! < $1.name!
        }
    }
    public var userBarDrinks: [Drink] {
        let set = userBar!.drinks as? Set<Drink> ?? []
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
        self.salesTax = (self.cost * userBar!.salesTaxRate).rounded(digits:2)
        self.tipAmount = (self.tipPercentage * self.subtotal).rounded(digits: 2)
        self.cost = (self.subtotal + self.salesTax + self.tipAmount).rounded(digits: 2)
    }
    public func emptyCart () {
        self.userId = ""
        self.barId = ""
        self.cost = 0.0
        self.drinks = NSSet.init(array: [Drink]())
    }
}
extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
