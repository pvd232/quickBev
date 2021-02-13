//
//  DrinkViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 3/29/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import Alamofire

class DrinkViewController: UIViewController {
    
    var drink : Drink
    @UsesAutoLayout var drinkImageStackView = UIStackView()
    @UsesAutoLayout var drinkDescriptionLabel = UITextView()
    @UsesAutoLayout var drinkPriceLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var drinkImageView = UIImageView()
    @UsesAutoLayout var drinkQuantityStackView = UIStackView()
    @UsesAutoLayout var minusButton = RoundButton()
    @UsesAutoLayout var plusButton = RoundButton()
    @UsesAutoLayout var drinkQuantityLabel = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var addToOrderButton = UIButton()
    // let testAPIKey = pk_test_51I0xFxFseFjpsgWvepMo3sJRNB4CCbFPhkxj2gEKgHUhIGBnciTqNVzjz1wz68Btbd5zAb2KC9eXpYaiOwLDA5QH00SZhtKPLT
    
    init(drink: Drink) {
//        print("drink", drink)
        self.drink = drink

        super.init(nibName: nil, bundle: nil)
        print("self.drink", self.drink as Any)
        print("self.drink", self.drink as Any)
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder not set up")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.view.addSubview(drinkImageStackView)
        self.view.addSubview(drinkQuantityStackView)
        self.view.addSubview(addToOrderButton)
        
        drinkImageStackView.axis = .vertical
        drinkImageStackView.spacing = 30.0
        drinkImageStackView.addArrangedSubview(drinkImageView)
        drinkImageStackView.addArrangedSubview(drinkDescriptionLabel)
        drinkImageStackView.addArrangedSubview(drinkPriceLabel)

        drinkQuantityStackView.axis = .horizontal
        drinkQuantityStackView.spacing = 30.0
        drinkQuantityStackView.addArrangedSubview(minusButton)
        drinkQuantityStackView.addArrangedSubview(drinkQuantityLabel)
        
        drinkQuantityStackView.addArrangedSubview(plusButton)
        

        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            addToOrderButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            drinkImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7),
            drinkImageView.heightAnchor.constraint(equalTo: drinkImageView.widthAnchor),
            drinkImageStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            drinkImageStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40.0),
            drinkImageStackView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.65),
            drinkQuantityStackView.topAnchor.constraint(equalTo: drinkImageStackView.bottomAnchor, constant: 27.5),
            drinkQuantityStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            addToOrderButton.topAnchor.constraint(greaterThanOrEqualTo: drinkImageStackView.bottomAnchor, constant: 70.0).usingPriority(UILayoutPriority(750)),
            addToOrderButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            addToOrderButton.widthAnchor.constraint(equalTo: addToOrderButton.superview!.widthAnchor),
            addToOrderButton.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.143032),
            addToOrderButton.bottomAnchor.constraint(equalTo: addToOrderButton.superview!.bottomAnchor)
        ])
        navigationItem.title = drink.name
        let drinkImage = UIImage(named: drink.name!.lowercased())

        drinkImageView.image = drinkImage

        drinkDescriptionLabel.text = drink.detail
        drinkDescriptionLabel.font = UIFont.themeLabelFont
        drinkDescriptionLabel.textAlignment = .center

        drinkQuantityLabel.text = String(drink.quantity)
        drinkQuantityLabel.font = UIFont.init(name: "Charter-Roman", size: 40.0)
        drinkQuantityLabel.textAlignment = .center

        // TODO: Possibly remove this label so as not to discourage purchases similar to Starbucks app
        drinkPriceLabel.text = "$\(drink.price.description)"
        drinkPriceLabel.font = UIFont.init(name: "Charter-Roman", size: 50.0)
        drinkPriceLabel.textAlignment = .center
        
        minusButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.144928).isActive = true
        minusButton.heightAnchor.constraint(equalTo: minusButton.widthAnchor, multiplier: 1.0).isActive = true
        minusButton.cornerRadius = minusButton.safeAreaLayoutGuide.layoutFrame.width / 2
        minusButton.setTitle("-", for: .normal)
        minusButton.titleLabel?.font = UIFont.systemFont(ofSize: 55.0)
        minusButton.contentVerticalAlignment = .bottom
        minusButton.refreshColor(color: UIColor.themeColor)
        
        plusButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.144928).isActive = true
        plusButton.heightAnchor.constraint(equalTo: plusButton.widthAnchor, multiplier: 1.0).isActive = true
        plusButton.cornerRadius = plusButton.safeAreaLayoutGuide.layoutFrame.width / 2
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 45.0)

        plusButton.contentVerticalAlignment = .top
        plusButton.refreshColor(color: UIColor.themeColor)
        
        addToOrderButton.setTitle("Add to Order", for: .normal)
        addToOrderButton.backgroundColor =  UIColor.themeColor
        addToOrderButton.titleLabel?.font = UIFont.init(name: "Charter-Black", size: 35.0)
        addToOrderButton.contentHorizontalAlignment = .center
        
        minusButton.addTarget(self, action: #selector(decreaseDrinkQuantity), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(increaseDrinkQuantity), for: .touchUpInside)
        addToOrderButton.addTarget(self, action: #selector(buyButtonPressed), for: .touchUpInside)

        
    }
    override func viewWillAppear(_ animated: Bool) {
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Charter-Roman", size: 25)!]
        self.navigationController!.navigationBar.standardAppearance.titleTextAttributes  = attributes   
    }
    @objc func increaseDrinkQuantity () {
        drink.quantity += 1
        drinkQuantityLabel.text = drink.quantity.description
    }
    @objc func decreaseDrinkQuantity () {
        drink.quantity -= 1
        drinkQuantityLabel.text = drink.quantity.description
    }
    @objc func buyButtonPressed(_ sender: RoundButton) {
        // this is the guest checkout process
        if CheckoutCart.shared.isGuest == true {
            CheckoutCart.shared.businessId = CheckoutCart.shared.userBusiness!.id!
            self.alertError()
        }
        else {
            CheckoutCart.shared.userId = CheckoutCart.shared.user!.email
            CheckoutCart.shared.businessId = CheckoutCart.shared.userBusiness!.id!
            CheckoutCart.shared.addToDrinks(drink)
            
            alertSuccess()
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        CoreDataManager.sharedManager.saveContext()
//        drink!.quantity = 1
    }
    
    private func alertError() {
        return self.alert(
            title: "",
            message: "You must create a QuickBev account to make a purchase. Don't worry, it only takes a minute. ",
            alertType: "error"
        )
    }
    
    private func alertSuccess() {
        return self.alert(
            title: "",
            message: "Your drink has been successfully added to your order.",
            alertType: "success"
        )
    }
    private func alertAccountCreation() {
        return self.alert(
            title: "",
            message: "Welcome to QuickBev! You may now proceed with your order.",
            alertType: "accountCreation"
        )
    }
    private func alert(title: String, message: String, alertType: String) {

        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if alertType == "error"{
            alertCtrl.addAction(UIAlertAction(title: "Okay", style: .cancel) { action in
                let registrationSplashPageViewController =   RegistrationSplashPageViewController()
                    self.navigationController?.pushViewController(registrationSplashPageViewController, animated: true)
            })
        }
        else {
            alertCtrl.addAction(UIAlertAction(title: "Okay", style: .cancel) { action in
                self.navigationController!.popViewController(animated: true)
            })
        }
        present(alertCtrl, animated: true, completion: nil)
    }
}
