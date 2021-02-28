//
//  DrinkListTableViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 3/29/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import os
import UIKit

class DrinkListTableViewController: UITableViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("coder not set up")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.setHidesBackButton(false, animated: true)
        tableView.register(DrinkTableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return CheckoutCart.shared.userBusinessDrinks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DrinkTableViewCell
        cell.name.text = CheckoutCart.shared.userBusinessDrinks[indexPath.row].name
        cell.drinkImageView.image = UIImage(named: CheckoutCart.shared.userBusinessDrinks[indexPath.row].name!.lowercased())
        cell.miscellaneousText.text = CheckoutCart.shared.userBusinessDrinks[indexPath.row].detail
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return (tableView.frame.height / 8)
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDrink = CheckoutCart.shared.userBusinessDrinks[indexPath.row].copy() as! Drink
        CheckoutCart.guestDrink = selectedDrink
        navigationController!.pushViewController(DrinkViewController(drink: selectedDrink), animated: true)
    }
}
