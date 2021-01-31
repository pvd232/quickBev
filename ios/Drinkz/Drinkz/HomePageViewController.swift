//
//  HomePageViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 6/3/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import Stripe

class HomePageViewController: UIViewController, NewBusinessPickedProtocol{
    
    let moonImage = UIImage(named:"moon")
    @UsesAutoLayout var moonImageView = UIImageView()
    @UsesAutoLayout var bottomButtonsViewContainer = UIView()
    @UsesAutoLayout var bottomButtonsStackView = UIStackView()
    
    @UsesAutoLayout var theNightIsYoungStackView = UIStackView()
    @UsesAutoLayout var goodEveningLabel = UILabel()
    @UsesAutoLayout var ellipsisLabel = UILabel()
    @UsesAutoLayout var theNightisYoungLabel = UILabel()
    
    @UsesAutoLayout var centerButton = RoundButton()
    @UsesAutoLayout var orderButton = UIButton()
    @UsesAutoLayout var accountButton = UIButton()
    @UsesAutoLayout var eventsButton = UIButton()
    @UsesAutoLayout var receiptsButton = UIButton()
    
    @UsesAutoLayout var navigationBarChevronArrowImageView = UIImageView()
    @UsesAutoLayout var navigationBarLocationArrowImageView = UIImageView()
    @UsesAutoLayout var navigationBarStackView = UIStackView()
    @UsesAutoLayout var navigationBarLabel = UILabel()
    
    var businesses = [Business]()
    var drinks = [Drink]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder not set up")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(moonImageView)
        self.view.addSubview(theNightIsYoungStackView)
        self.view.addSubview(centerButton)
        self.view.addSubview(bottomButtonsViewContainer)
        
        moonImageView.image = moonImage
        
        centerButton.refreshColor(color: UIColor.themeColor)
        centerButton.titleLabel?.font = UIFont.themeButtonFont
        
        accountButton.setTitle("Account", for: .normal)
        accountButton.titleLabel?.font = UIFont.themeButtonFont
        
        eventsButton.setTitle("Events", for: .normal)
        eventsButton.titleLabel?.font = UIFont.themeButtonFont
        
        receiptsButton.setTitle("Receipts", for: .normal)
        receiptsButton.titleLabel?.font = UIFont.themeButtonFont
        
        orderButton.setTitle("Order", for: .normal)
        orderButton.titleLabel?.font = UIFont.themeButtonFont
        
        theNightIsYoungStackView.axis = .vertical
        theNightIsYoungStackView.spacing = 10.0
        theNightIsYoungStackView.alignment = .center
        theNightIsYoungStackView.addArrangedSubview(goodEveningLabel)
        theNightIsYoungStackView.addArrangedSubview(ellipsisLabel)
        theNightIsYoungStackView.addArrangedSubview(theNightisYoungLabel)
        
        bottomButtonsViewContainer.addSubview(bottomButtonsStackView)
        bottomButtonsViewContainer.backgroundColor = UIColor.themeColor
        
        bottomButtonsStackView.axis = .horizontal
        bottomButtonsStackView.distribution = .fillProportionally
        bottomButtonsStackView.alignment = .top
        bottomButtonsStackView.spacing = 30
        bottomButtonsStackView.addArrangedSubview(accountButton)
        bottomButtonsStackView.addArrangedSubview(receiptsButton)
        bottomButtonsStackView.addArrangedSubview(orderButton)
        bottomButtonsStackView.addArrangedSubview(eventsButton)
        
        goodEveningLabel.font = UIFont(name: "Charter-Roman", size: 30.0)
        goodEveningLabel.textAlignment = .center
        
        theNightisYoungLabel.text = "The night is young"
        theNightisYoungLabel.font = UIFont(name: "Charter-Roman", size: 30.0)
        theNightisYoungLabel.textAlignment = .center
        
        
        ellipsisLabel.text = "· · ·"
        ellipsisLabel.font = UIFont(name: "Charter-Roman", size: 30.0)
        ellipsisLabel.textAlignment = .center
        
        navigationBarLabel.font = UIFont(name: "Charter-Roman", size: 20)
        navigationBarStackView.spacing = 10
        let chevronArrowImage = UIImage(systemName: "chevron.down")
        let locationArrowImage = UIImage(systemName: "location.fill")
        navigationBarChevronArrowImageView.image = chevronArrowImage!
        navigationBarLocationArrowImageView.image = locationArrowImage!
        navigationBarStackView.addArrangedSubview(navigationBarLocationArrowImageView)
        navigationBarStackView.addArrangedSubview(navigationBarLabel)
        navigationBarStackView.addArrangedSubview(navigationBarChevronArrowImageView)
        self.navigationItem.titleView = navigationBarStackView
        
        
        let margins = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            theNightIsYoungStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -20.0),
            theNightIsYoungStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20.0),
            theNightIsYoungStackView.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: -30.0),
            theNightIsYoungStackView.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            
            centerButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            centerButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.9),
            centerButton.heightAnchor.constraint(equalTo: centerButton.widthAnchor, multiplier: (25/197)),
            
            bottomButtonsStackView.centerXAnchor.constraint(equalTo: bottomButtonsStackView.superview!.centerXAnchor),
            bottomButtonsStackView.heightAnchor.constraint(equalTo: bottomButtonsStackView.superview!.heightAnchor, multiplier: 0.9),
            bottomButtonsStackView.widthAnchor.constraint(equalTo: bottomButtonsStackView.superview!.widthAnchor, multiplier: 0.95),
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: bottomButtonsStackView.superview!.bottomAnchor),
            
            bottomButtonsViewContainer.bottomAnchor.constraint(equalTo: bottomButtonsViewContainer.superview!.bottomAnchor, constant: 0.0),
            bottomButtonsViewContainer.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            bottomButtonsViewContainer.topAnchor.constraint(equalTo: centerButton.bottomAnchor, constant: 134),
            bottomButtonsViewContainer.widthAnchor.constraint(equalTo: margins.widthAnchor),
            bottomButtonsViewContainer.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.12),
            
            moonImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40.0),
            moonImageView.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.35),
            moonImageView.widthAnchor.constraint(equalTo: moonImageView.heightAnchor),
            moonImageView.centerXAnchor.constraint(equalTo: margins.centerXAnchor)
        ])
        accountButton.addTarget(self, action: #selector(launchAccountViewController), for: .touchUpInside)
        
        orderButton.addTarget(self, action: #selector(launchCheckoutViewController), for: .touchUpInside)
        
        centerButton.addTarget(self, action: #selector(centerButtonTouchup), for: .touchUpInside)
        navigationBarStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(launchBusinessViewController)))
        
        // initialize checkout cart
        let _ = CheckoutCart.customerContext
        if CheckoutCart.shared.user == nil {
            centerButton.refreshTitle(newTitle: "Choose a venue")
            goodEveningLabel.text = "Good evening"
            bottomButtonsStackView.isHidden = true
        } else {
            goodEveningLabel.text = "Good evening, \(CheckoutCart.shared.user!.firstName!.capitalizingFirstLetter())"
            bottomButtonsStackView.isHidden = false
        }
        if CheckoutCart.shared.userBusiness == nil {
            centerButton.refreshTitle(newTitle: "Choose your venue")
            navigationBarStackView.isHidden = true
        }
        else {
            navigationBarStackView.isHidden = false
            navigationBarStackView.isUserInteractionEnabled = true
            centerButton.refreshTitle(newTitle: "Order from \(CheckoutCart.shared.userBusiness!.name!)")
            navigationBarLabel.text = CheckoutCart.shared.userBusiness!.name
        }
        bottomButtonsViewContainer.backgroundColor = UIColor.init(red: 134/255, green: 130/255, blue: 230/255, alpha: 1.0)
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        var fetchedDrinksOrBusinessesBool = false
        
        let group = DispatchGroup()
        group.enter()
        if let fetchedBusinesses = CoreDataManager.sharedManager.fetchEntities(entityName: "Business", context:managedContext) as? [Business], fetchedBusinesses.count > 0 {
            businesses = fetchedBusinesses
            group.leave()
        } else {
            Business.getBusinesses() {
                businessesFromAPICall in
                guard businessesFromAPICall != nil else {
                    return
                }
                self.businesses = businessesFromAPICall!
                fetchedDrinksOrBusinessesBool = true
                group.leave()
            }
        }
        group.enter()
        if let fetchedDrinks = CoreDataManager.sharedManager.fetchEntities(entityName: "Drink", context:managedContext) as? [Drink], fetchedDrinks.count > 0 {
            drinks = fetchedDrinks
            group.leave()
        } else {
            Drink.getDrinks() { drinksFromAPICall in
                guard drinksFromAPICall != nil else {
                    return
                }
                self.drinks = drinksFromAPICall!
                fetchedDrinksOrBusinessesBool = true
                group.leave()
            }
        }
        group.notify(queue: .main, execute: {
            // executed after all async calls in for loop finish
            if fetchedDrinksOrBusinessesBool == true {
                for business in self.businesses{
                    var businessDrinks = [Drink]()
                    for drink in self.drinks {
                        if drink.businessAddressId == business.businessAddressId {
                            businessDrinks.append(drink)
                            drink.drinkToBusiness = business
                        }
                    }
                    business.drinks = NSSet.init(array: businessDrinks)
                }
                CheckoutCart.shared.business = NSSet.init(array: self.businesses)
                CoreDataManager.sharedManager.saveContext(context: managedContext)
            }
        })
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.init(red: 134/255, green: 130/255, blue: 230/255, alpha: 1.0)
//    }
    
    @objc func launchAccountViewController () {
        navigationController?.pushViewController(AccountViewController(), animated: true)
    }
    
    @objc func launchBusinessViewController () {
        let popoverContent = BusinessMapViewController()
        popoverContent.modalPresentationStyle = .popover
        let popover = popoverContent.popoverPresentationController
        popover!.sourceView = navigationBarStackView
        
        // the position of the popover where it's showed
        popover!.sourceRect = self.view!.bounds
        
        // the size you want to display
        popoverContent.preferredContentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        popoverContent.businessPickerDelegate = self
        popover!.delegate = self
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    @objc func launchCheckoutViewController () {
        let viewController = CheckoutViewController()
            navigationController?.pushViewController(viewController, animated: true)
    }
    
    func businessPicked() {
        centerButton.refreshTitle(newTitle: "Order from \(CheckoutCart.shared.userBusiness!.name!)")
        navigationBarLabel.text = CheckoutCart.shared.userBusiness!.name
        navigationBarStackView.isHidden = false
    }
    @objc func centerButtonTouchup(_ sender: RoundButton) {
        if CheckoutCart.shared.userBusiness != nil {
            let drinkListTableViewController = DrinkListTableViewController()
            navigationController?.pushViewController(drinkListTableViewController, animated: true)
        }
        else {
            launchBusinessViewController()
        }
    }
}
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
extension HomePageViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.fullScreen
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        return UINavigationController(rootViewController: controller.presentedViewController)
    }
}
extension UIColor {
    class var themeColor:UIColor {
        return UIColor.init(red: 134/255, green: 130/255, blue: 230/255, alpha: 1.0)
    }
}
extension UIFont {
    class var themeButtonFont:UIFont {
        return UIFont.init(name: "Charter-Black", size: 20.0)!
    }
    class var themeLabelFont:UIFont {
        return UIFont.init(name: "Charter-Roman", size: 20.0)!
    }
    class var themeLabelSmallFont:UIFont {
        return UIFont.init(name: "Charter-Roman", size: 14.0)!
    }
}
@propertyWrapper
public struct UsesAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}

