//
//  DrinkListTableViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 3/29/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import Alamofire
import os

class DrinkListTableViewController: UITableViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder not set up")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.navigationItem.setHidesBackButton(false, animated: true)
        self.tableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CheckoutCart.shared.userBarDrinks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DrinkTableViewCell
        cell.name.text = CheckoutCart.shared.userBarDrinks[indexPath.row].name
        cell.drinkImageView.image = UIImage(named: CheckoutCart.shared.userBarDrinks[indexPath.row].name!.lowercased())
        cell.miscellaneousText.text = CheckoutCart.shared.userBarDrinks[indexPath.row].detail
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDrink = CheckoutCart.shared.userBarDrinks[indexPath.row].copy() as! Drink
        print("selectedDrink", selectedDrink)
//        let mainStoryBoard = UIStoryboard(name:"Main", bundle: nil)
        let viewController =  DrinkViewController(drink:selectedDrink)
            navigationController!.pushViewController(viewController, animated: true)
    }
}
