//
//  ReviewOrderViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/1/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class ReviewOrderViewController: UIViewController {
    @IBOutlet weak var defaultPaymentMethodView: UIView!
    @IBOutlet weak var cardLogoImageView: UIImageView!
    @IBOutlet weak var cardCompanyName: UILabel!
    @IBOutlet weak var orderSubtotalLabel: UILabel!
    @IBOutlet weak var salesTaxLabel: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var addPaymentMethodButton: RoundButton!
    @IBOutlet weak var orderTotalLabel: UILabel!
    
    // need to dynamically apply this based on bar location the user is at, should probably store a list of states and associated sales taxes in core data when first loading the app
    var paymentContext: STPPaymentContext?
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentContext = STPPaymentContext(customerContext: CheckoutCart.customerContext)
        paymentContext!.delegate = self
        paymentContext!.hostViewController = self
        CheckoutCart.shared.calculateCost()
        paymentContext!.paymentAmount = Int((CheckoutCart.shared.cost * 100).rounded(digits:2)) // This is in cents, i.e. $50 USD
        orderSubtotalLabel.text = String(CheckoutCart.shared.subtotal)
        salesTaxLabel.text = String(CheckoutCart.shared.salesTax)
        tipAmountLabel.text = String(CheckoutCart.shared.tipAmount)
        orderTotalLabel.text = "$" + String(CheckoutCart.shared.cost)
        paymentContextDidChange(paymentContext!)
    }
    
    @IBAction func choosePaymentButtonTapped(_ sender: RoundButton) {
        // TODO: finish setting up payment method and implement submit order functionality. chain customer to their payment method in backend
        if self.paymentContext!.selectedPaymentOption != nil {
            self.paymentContext!.requestPayment()
        }
        else {
            paymentContext!.presentPaymentOptionsViewController()
        }
    }
    
    @IBAction func changeDefaultPaymentMethodButtonClicked(_ sender: RoundButton) {
        paymentContext!.presentPaymentOptionsViewController()
    }
}
extension ReviewOrderViewController: STPPaymentContextDelegate {
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print(error)
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if self.paymentContext!.selectedPaymentOption != nil {
            defaultPaymentMethodView.isHidden = false
            cardCompanyName.text =  self.paymentContext!.selectedPaymentOption?.label
            cardLogoImageView.image = self.paymentContext!.selectedPaymentOption!.templateImage
            addPaymentMethodButton.refreshTitle(newTitle: "Submit Order")
        }
        else {
            defaultPaymentMethodView.isHidden = true
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        print("payment context")
        let orderToBeSubmitted = Order(checkoutCart: CheckoutCart.shared)
        StripeAPIClient.sharedAPIClient.createPaymentIntent(order: orderToBeSubmitted ) { result in
            switch result {
            case .success(let clientSecret):
                // Assemble the PaymentIntent parameters
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                paymentIntentParams.paymentMethodId = paymentResult.paymentMethod?.stripeId
                
                // Confirm the PaymentIntent
                STPPaymentHandler.shared().confirmPayment(paymentIntentParams, with: paymentContext) { status, paymentIntent, error in
                    switch status {
                    case .succeeded:
                        // Your backend asynchronously fulfills the customer's order, e.g. via webhook
                        let encoder = JSONEncoder()
                        let encodedOrder = try! encoder.encode(orderToBeSubmitted)
                        let orderJson = try! JSONSerialization.jsonObject(with:encodedOrder, options: []) as! Parameters
                        
                        AF.request("http://127.0.0.1:5000/orders", method: .post, parameters: orderJson, encoding: JSONEncoding.default)
                            .validate()
                            .responseJSON { response in
                                debugPrint("response", response)
                                switch response.result {
                                case .success:
                                    print("successfully posted order")
                                    completion(.success, nil)
                                case .failure (let error):
                                    completion(.error, nil)
                                    print("error", error)
                                    
                                }
                            }
                    case .failed:
                        completion(.error, error) // Report error
                    case .canceled:
                        completion(.userCancellation, nil) // Customer cancelled
                    @unknown default:
                        completion(.error, nil)
                    }
                }
            case .failure(let error):
                completion(.error, error) // Report error from your API
                break
            }
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        let title: String
        let message: String
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            CheckoutCart.shared.emptyCart()
            title = "Success"
            message = "Your purchase was successful!"
        case .userCancellation:
            return()
        @unknown default:
            return()
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .cancel) { action in
            let nextViewController = self.storyboard?.instantiateViewController(identifier: "OrderConfirmationViewController")
            self.navigationController?.setViewControllers([nextViewController!], animated: true)
        })
        self.present(alertController, animated: true, completion: nil)
        }
    
}

