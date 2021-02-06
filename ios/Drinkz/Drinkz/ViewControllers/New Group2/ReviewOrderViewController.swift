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
    @UsesAutoLayout var orderSummaryStackView = UIStackView()
    @UsesAutoLayout var orderSummaryLabel = UILabel()
    @UsesAutoLayout var subtotalStackView = UIStackView()
    @UsesAutoLayout var subtotalHeaderLabel = UILabel()
    @UsesAutoLayout var salesTaxStackView = UIStackView()
    @UsesAutoLayout var salesTaxHeaderLabel = UILabel()
    @UsesAutoLayout var tipStackView = UIStackView()
    @UsesAutoLayout var tipHeaderLabel = UILabel()
    @UsesAutoLayout var totalStackView = UIStackView()
    @UsesAutoLayout var totalHeaderLabel = UILabel()
    
    @UsesAutoLayout var defaultPaymentMethodView = UIView()
    @UsesAutoLayout var cardLogoImageView = UIImageView()
    @UsesAutoLayout var cardCompanyName = UILabel()
    @UsesAutoLayout var orderSubtotalLabel = UILabel()
    @UsesAutoLayout var salesTaxLabel = UILabel()
    @UsesAutoLayout var tipAmountLabel = UILabel()
    @UsesAutoLayout var addPaymentMethodButton = RoundButton()
    @UsesAutoLayout var changePaymentMethodButton = RoundButton()
    @UsesAutoLayout var orderTotalLabel = UILabel()
    
    // need to dynamically apply this based on business location the user is at, should probably store a list of states and associated sales taxes in core data when first loading the app
    var paymentContext: STPPaymentContext?
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder not set up")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentContext = STPPaymentContext(customerContext: CheckoutCart.customerContext)
        paymentContext!.delegate = self
        paymentContext!.hostViewController = self
        CheckoutCart.shared.calculateCost()
        paymentContext!.paymentAmount = Int((CheckoutCart.shared.cost * 100).rounded(digits:2)) // This is in cents, i.e. $50 USD
        
        // page content and formatting
        
        orderSummaryLabel.text = "Order summary"
        orderSummaryLabel.font = UIFont.init(name: "Charter-Roman", size: 40.0)
        
        subtotalHeaderLabel.text = "Subtotal"
        subtotalHeaderLabel.font = UIFont.init(name: "Charter-Black", size: 18.0)

        orderSubtotalLabel.text = String(CheckoutCart.shared.subtotal)
        orderSubtotalLabel.font = UIFont.init(name: "Charter-Roman", size: 18.0)
        orderSubtotalLabel.setContentHuggingPriority(UILayoutPriority(500), for: .horizontal)

        salesTaxHeaderLabel.text = "Sales tax"
        salesTaxHeaderLabel.font = UIFont.init(name: "Charter-Roman", size: 18.0)

        salesTaxLabel.text = String(CheckoutCart.shared.salesTax)
        salesTaxLabel.font = UIFont.init(name: "Charter-Roman", size: 18.0)
        salesTaxLabel.setContentHuggingPriority(UILayoutPriority(500), for: .horizontal)
        
        tipHeaderLabel.text = "Tip (10%)"
        tipHeaderLabel.font = UIFont.init(name: "Charter-Roman", size: 18.0)
        
        tipAmountLabel.text = String(CheckoutCart.shared.tipAmount)
        tipAmountLabel.font = UIFont.init(name: "Charter-Roman", size: 18.0)
        tipAmountLabel.setContentHuggingPriority(UILayoutPriority(500), for: .horizontal)

        totalHeaderLabel.text = "Total"
        totalHeaderLabel.font = UIFont.init(name: "Charter-Black", size: 24.0)
        
        orderTotalLabel.text = "$" + String(CheckoutCart.shared.cost)
        orderTotalLabel.font = UIFont.init(name: "Charter-Black", size: 24.0)
        orderTotalLabel.setContentHuggingPriority(UILayoutPriority(500), for: .horizontal)

        orderSummaryStackView.axis = .vertical
        orderSummaryStackView.spacing = 20.0
        orderSummaryStackView.addArrangedSubview(orderSummaryLabel)
        orderSummaryStackView.addArrangedSubview(subtotalStackView)
        orderSummaryStackView.addArrangedSubview(salesTaxStackView)
        orderSummaryStackView.addArrangedSubview(tipStackView)
        orderSummaryStackView.addArrangedSubview(totalStackView)
        
        subtotalStackView.axis = .horizontal
        subtotalStackView.addArrangedSubview(subtotalHeaderLabel)
        subtotalStackView.addArrangedSubview(orderSubtotalLabel)

        salesTaxStackView.axis = .horizontal
        salesTaxStackView.addArrangedSubview(salesTaxHeaderLabel)
        salesTaxStackView.addArrangedSubview(salesTaxLabel)
        
        tipStackView.axis = .horizontal
        tipStackView.addArrangedSubview(tipHeaderLabel)
        tipStackView.addArrangedSubview(tipAmountLabel)
        
        totalStackView.axis = .horizontal
        totalStackView.addArrangedSubview(totalHeaderLabel)
        totalStackView.addArrangedSubview(orderTotalLabel)

        defaultPaymentMethodView.addSubview(cardLogoImageView)
        defaultPaymentMethodView.addSubview(cardCompanyName)
        defaultPaymentMethodView.addSubview(changePaymentMethodButton)
        
        changePaymentMethodButton.refreshColor(color: UIColor.themeColor)
        changePaymentMethodButton.refreshTitle(newTitle: "change")
        changePaymentMethodButton.titleLabel?.font = UIFont.init(name: "Charter-Black", size: 20.0)
        
        addPaymentMethodButton.refreshColor(color: UIColor.themeColor)
        addPaymentMethodButton.titleLabel?.font = UIFont.init(name: "Charter-Black", size: 20.0)
        addPaymentMethodButton.refreshTitle(newTitle: "Add payment method")
        
        self.view.addSubview(orderSummaryStackView)
        self.view.addSubview(defaultPaymentMethodView)
        self.view.addSubview(addPaymentMethodButton)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            addPaymentMethodButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10.0),
            addPaymentMethodButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10.0),
            orderSummaryStackView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.33),
            orderSummaryStackView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.90),
            orderSummaryStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20.0),
            orderSummaryStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            defaultPaymentMethodView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.0841584),
            defaultPaymentMethodView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.90),
            defaultPaymentMethodView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            defaultPaymentMethodView.topAnchor.constraint(equalTo: orderSummaryStackView.bottomAnchor, constant: 35.0),
            addPaymentMethodButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10.0),
            addPaymentMethodButton.widthAnchor.constraint(equalTo: addPaymentMethodButton.heightAnchor, multiplier: (373/60)),
            
            // default method subview constraints
            cardLogoImageView.centerYAnchor.constraint(equalTo: cardLogoImageView.superview!.centerYAnchor),
            cardLogoImageView.widthAnchor.constraint(equalTo: cardLogoImageView.superview!.widthAnchor, multiplier: 0.15),
            cardLogoImageView.heightAnchor.constraint(equalTo: cardLogoImageView.superview!.heightAnchor, multiplier: 0.529412),
            cardLogoImageView.leadingAnchor.constraint(equalTo: cardLogoImageView.superview!.leadingAnchor),
            cardCompanyName.widthAnchor.constraint(equalTo: cardCompanyName.superview!.widthAnchor, multiplier: 0.365517),
            cardCompanyName.leadingAnchor.constraint(equalTo: cardLogoImageView.trailingAnchor, constant: 20.0),
            cardCompanyName.centerYAnchor.constraint(equalTo: cardCompanyName.superview!.centerYAnchor),
            changePaymentMethodButton.heightAnchor.constraint(equalTo: changePaymentMethodButton.superview!.heightAnchor, multiplier: 0.497059),
            changePaymentMethodButton.trailingAnchor.constraint(equalTo: changePaymentMethodButton.superview!.trailingAnchor),
            changePaymentMethodButton.widthAnchor.constraint(greaterThanOrEqualTo: changePaymentMethodButton.superview!.widthAnchor, multiplier: 0.25),
            changePaymentMethodButton.centerYAnchor.constraint(equalTo: changePaymentMethodButton.superview!.centerYAnchor)
        ])
        paymentContextDidChange(paymentContext!)
        addPaymentMethodButton.addTarget(self, action: #selector(choosePaymentButtonTapped), for: .touchUpInside)
        changePaymentMethodButton.addTarget(self, action: #selector(changeDefaultPaymentMethodButtonClicked), for: .touchUpInside)
    }
    
    @objc func choosePaymentButtonTapped(_ sender: RoundButton) {
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
                        
                        AF.request("http://127.0.0.1:5000/order", method: .post, parameters: orderJson, encoding: JSONEncoding.default)
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
            CoreDataManager.sharedManager.saveContext()
            title = "Success"
            message = "Your purchase was successful!"
        case .userCancellation:
            return()
        @unknown default:
            return()
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .cancel) { action in
            self.navigationController?.setViewControllers([OrderConfirmationViewController()], animated: true)
        })
        self.present(alertController, animated: true, completion: nil)
        }
    
}

