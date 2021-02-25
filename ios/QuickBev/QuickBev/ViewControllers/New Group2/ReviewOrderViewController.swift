//
//  ReviewOrderViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/1/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import Stripe

class ReviewOrderViewController: UIViewController {
    @UsesAutoLayout var orderSummaryStackView = UIStackView()
    @UsesAutoLayout var orderSummaryLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var subtotalStackView = UIStackView()
    @UsesAutoLayout var subtotalHeaderLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var salesTaxStackView = UIStackView()
    @UsesAutoLayout var salesTaxHeaderLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var tipStackView = UIStackView()
    @UsesAutoLayout var tipHeaderLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var totalStackView = UIStackView()
    @UsesAutoLayout var totalHeaderLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    
    @UsesAutoLayout var defaultPaymentMethodView = UIView()
    @UsesAutoLayout var cardLogoImageView = UIImageView()
    @UsesAutoLayout var cardCompanyName = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var orderSubtotalLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var salesTaxLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var tipAmountLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var addPaymentMethodButton = RoundButton()
    @UsesAutoLayout var changePaymentMethodButton = RoundButton()
    @UsesAutoLayout var orderTotalLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    // need to dynamically apply this based on business location the user is at, should probably store a list of states and associated sales taxes in core data when first loading the app
    var paymentContext: STPPaymentContext?
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder not set up")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // load subviews
        self.view.addSubview(orderSummaryStackView)
        self.view.addSubview(defaultPaymentMethodView)
        self.view.addSubview(addPaymentMethodButton)
        self.view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        // setup stripe
        paymentContext = STPPaymentContext(customerContext: CheckoutCart.customerContext)
        paymentContext!.delegate = self
        paymentContext!.hostViewController = self
        CheckoutCart.shared.calculateCost()
        // this is the amount that is displayed to the user on the screen
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
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: activityIndicator.superview!.widthAnchor),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.superview!.heightAnchor),
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
            activityIndicator.startAnimating()
            self.paymentContext!.requestPayment()
        }
        else {
            paymentContext!.presentPaymentOptionsViewController()
        }
    }
    
    @objc func changeDefaultPaymentMethodButtonClicked(_ sender: RoundButton) {
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
                        let request = try! APIRequest(method: .post, path: "/order", body: orderToBeSubmitted)
                        APIClient().perform(request) { result in
                            switch result {
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
        self.activityIndicator.stopAnimating()
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

