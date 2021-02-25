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
    
//    let moonImage = UIImage(named:"moon")
    @UsesAutoLayout var logoImageView = UIImageView.LogoImageView
    @UsesAutoLayout var bottomButtonsViewContainer = ToolbarView()
    
    @UsesAutoLayout var theNightIsYoungStackView = UIStackView()
    @UsesAutoLayout var goodEveningLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var ellipsisLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var theNightisYoungLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    
    @UsesAutoLayout var centerButton = RoundButton()
    
    @UsesAutoLayout var navigationBarChevronArrowImageView = UIImageView()
    @UsesAutoLayout var navigationBarLocationArrowImageView = UIImageView()
    @UsesAutoLayout var navigationBarStackView = UIStackView()
    @UsesAutoLayout var navigationBarLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    var didLayoutBadgeNotification = false
    
    var businesses = [Business]()
    var drinks = [Drink]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder not set up")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(logoImageView)
        self.view.addSubview(theNightIsYoungStackView)
        self.view.addSubview(centerButton)
        self.view.addSubview(bottomButtonsViewContainer)
        print("hey")
        centerButton.refreshColor(color: UIColor.themeColor)
        centerButton.titleLabel?.font = UIFont.themeButtonFont
        
        theNightIsYoungStackView.axis = .vertical
        theNightIsYoungStackView.spacing = 5.0
        theNightIsYoungStackView.alignment = .center
        theNightIsYoungStackView.addArrangedSubview(goodEveningLabel)
        theNightIsYoungStackView.addArrangedSubview(ellipsisLabel)
        theNightIsYoungStackView.addArrangedSubview(theNightisYoungLabel)
        
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
        
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            theNightIsYoungStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20.0),
            theNightIsYoungStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20.0),
            theNightIsYoungStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -30.0),
            theNightIsYoungStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            centerButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            centerButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            centerButton.heightAnchor.constraint(equalTo: centerButton.widthAnchor, multiplier: (25/197)),

            bottomButtonsViewContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
            bottomButtonsViewContainer.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            bottomButtonsViewContainer.topAnchor.constraint(equalTo: centerButton.bottomAnchor, constant: (UIViewController.screenSize.height * 0.12)),
            bottomButtonsViewContainer.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            bottomButtonsViewContainer.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.16),
            
            logoImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: CGFloat(0.565217)),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            logoImageView.bottomAnchor.constraint(lessThanOrEqualTo :theNightIsYoungStackView.topAnchor , constant: -10.0),
            logoImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: (0.02 * UIViewController.screenSize.height)),
        ])
    
        centerButton.addTarget(self, action: #selector(centerButtonTouchup), for: .touchUpInside)
        navigationBarStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(launchBusinessViewController)))
        
        // initialize checkout cart
        // this triggers the StripeAPI to call the create customer key function, sending the existing stripe id of the user returned from logging in as a parameter
        if let u = CoreDataManager.sharedManager.fetchEntities(entityName: "ETag") as? [ETag]{
            for e in u {
                print("etag.id", e.id)
                print("etag.category", e.category)

            }

        }
        
        let _ = CheckoutCart.customerContext
        if CheckoutCart.shared.user == nil {
            centerButton.refreshTitle(newTitle: "Choose a venue")
            goodEveningLabel.text = "Good evening"
        } else {
            goodEveningLabel.text = "Good evening, \(CheckoutCart.shared.user!.firstName!.capitalizingFirstLetter())"
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
        var fetchedDrinksOrBusinessesBool = false
        
        let group = DispatchGroup()
        group.enter()
        if let fetchedBusinesses = CoreDataManager.sharedManager.fetchEntities(entityName: "Business") as? [Business], fetchedBusinesses.count > 0 {
            print("1")
            Business.getBusinesses(APIClient: APIClient()) {
                businessesFromAPICall in
                guard businessesFromAPICall != nil else {
                    print("2")

                    self.businesses = fetchedBusinesses
                    return
                }
                CoreDataManager.sharedManager.deleteEntities(entityName: "Business")
                self.businesses = businessesFromAPICall!
                fetchedDrinksOrBusinessesBool = true
                group.leave()
            }
        } else {
            print("b")
            Business.getBusinesses(APIClient: APIClient()) {
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
        if let fetchedDrinks = CoreDataManager.sharedManager.fetchEntities(entityName: "Drink") as? [Drink], fetchedDrinks.count > 0 {
            print("3")
            Drink.getDrinks(APIClient: APIClient()) { drinksFromAPICall in
                guard drinksFromAPICall != nil else {
                    print("4")
                    self.drinks = fetchedDrinks
                    return
                }
                CoreDataManager.sharedManager.deleteEntities(entityName: "Drink")
                print("5")
                self.drinks = drinksFromAPICall!
                fetchedDrinksOrBusinessesBool = true
                group.leave()

            }
        } else {
            print("d")
            Drink.getDrinks(APIClient: APIClient()) { drinksFromAPICall in
                guard drinksFromAPICall != nil else {
                    return
                }
                self.drinks = drinksFromAPICall!
                fetchedDrinksOrBusinessesBool = true
                group.leave()
            }
        }
        group.notify(queue: .main, execute: {
            // if the drinks or businesses were fetched from an API call we must establish their relationships in core data and set them in the checkout cart
            print("fetchedDrinksOrBusinessesBool", fetchedDrinksOrBusinessesBool)
            if fetchedDrinksOrBusinessesBool == true {
                for business in self.businesses{
                    var businessDrinks = [Drink]()
                    for drink in self.drinks {
                        if drink.businessId == business.id {
                            businessDrinks.append(drink)
                            drink.drinkToBusiness = business
                        }
                    }
                    business.drinks = NSSet.init(array: businessDrinks)
                }
                CheckoutCart.shared.business = NSSet.init(array: self.businesses)
                CoreDataManager.sharedManager.saveContext()
            }
            // if the user has signed out of their account the shopping cart will be empty but the businesses and drinks will be saved in core data
            else if CheckoutCart.shared.businessArray.count == 0 {
//                if let fetchedBusinesses = CoreDataManager.sharedManager.fetchEntities(entityName: "Business") as? [Business] {
//                    for fetchedBusiness in fetchedBusinesses{
//                        print("fetchedBusiness in home", fetchedBusiness)
//                    }
//                }
                CheckoutCart.shared.business = NSSet.init(array: self.businesses)
                CoreDataManager.sharedManager.saveContext()
            }
        })
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
    override func viewDidAppear(_ animated: Bool) {
        didLayoutBadgeNotification = true
    }
    override func viewDidLayoutSubviews() {
        if didLayoutBadgeNotification == false {
            bottomButtonsViewContainer.hub!.moveCircleBy(x:bottomButtonsViewContainer.orderButton.frame.width, y: CGFloat(-4.0))
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        bottomButtonsViewContainer.hub!.setCount(CheckoutCart.shared.cart.count)
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
extension HomePageViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.fullScreen
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        return UINavigationController(rootViewController: controller.presentedViewController)
    }
}
