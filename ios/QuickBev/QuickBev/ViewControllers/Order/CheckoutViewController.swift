//
//  CheckoutViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 12/22/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @UsesAutoLayout var bottomButtonView = UIView()
    @UsesAutoLayout var bottomButtonStackView = UIStackView()
    @UsesAutoLayout var addMoreItemsButton = RoundButton()
    @UsesAutoLayout var reviewOrderButton = RoundButton()
    @UsesAutoLayout var tableView = UITableView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("coder not set up")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.backgroundColor = .white
        view.addSubview(bottomButtonView)
        bottomButtonView.addSubview(bottomButtonStackView)
        bottomButtonStackView.addArrangedSubview(addMoreItemsButton)
        bottomButtonStackView.addArrangedSubview(reviewOrderButton)

        bottomButtonStackView.axis = .horizontal
        bottomButtonStackView.distribution = .fillProportionally
        bottomButtonStackView.alignment = .top
        bottomButtonStackView.spacing = 20

        bottomButtonView.backgroundColor = UIColor.themeColor

        addMoreItemsButton.refreshColor(color: UIColor.white)
        addMoreItemsButton.refreshTitle(newTitle: "Add more items")
        addMoreItemsButton.titleLabel?.font = UIFont.themeButtonFont
        addMoreItemsButton.setTitleColor(UIColor.themeColor, for: .normal)

        reviewOrderButton.refreshColor(color: UIColor.white)
        reviewOrderButton.refreshTitle(newTitle: "Review order")
        reviewOrderButton.titleLabel?.font = UIFont.themeButtonFont
        reviewOrderButton.setTitleColor(UIColor.themeColor, for: .normal)

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            addMoreItemsButton.heightAnchor.constraint(equalTo: bottomButtonStackView.heightAnchor, multiplier: 0.6),
            reviewOrderButton.heightAnchor.constraint(equalTo: bottomButtonStackView.heightAnchor, multiplier: 0.6),
            bottomButtonStackView.widthAnchor.constraint(equalTo: bottomButtonView.widthAnchor, multiplier: 0.95),
            bottomButtonStackView.heightAnchor.constraint(equalTo: bottomButtonView.heightAnchor, multiplier: 0.7),
            bottomButtonStackView.bottomAnchor.constraint(equalTo: bottomButtonView.bottomAnchor, constant: 0.0),
            bottomButtonStackView.centerXAnchor.constraint(equalTo: bottomButtonView.centerXAnchor),
            bottomButtonView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            bottomButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomButtonView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.12),
            bottomButtonView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0.0),
            tableView.bottomAnchor.constraint(equalTo: bottomButtonView.topAnchor, constant: 0.0),

        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CheckoutCartTableViewCell.self, forCellReuseIdentifier: "CheckoutCartCell")

        addMoreItemsButton.addTarget(self, action: #selector(clickAddMoreItems), for: .touchUpInside)
        reviewOrderButton.addTarget(self, action: #selector(proceedToReviewOrder), for: .touchUpInside)
        CheckoutCart.shared.calculateCost()
    }

    override func viewWillAppear(_: Bool) {
        title = "Your Order"
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Charter-Roman", size: 25)!]
        navigationController!.navigationBar.standardAppearance.titleTextAttributes = attributes
    }

    @objc func clickAddMoreItems(_: RoundButton) {
        let homePageViewController = HomePageViewController()
        let drinkListTableViewController = DrinkListTableViewController()

        let navigationController = self.navigationController!
        navigationController.setViewControllers([drinkListTableViewController, homePageViewController], animated: true)
    }

    @objc func proceedToReviewOrder() {
        navigationController?.pushViewController(ReviewOrderViewController(), animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return (tableView.frame.height / 6)
    }

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return CheckoutCart.shared.cart.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCartCell", for: indexPath) as! CheckoutCartTableViewCell
        cell.name.text = "\(String(describing: CheckoutCart.shared.cart[indexPath.row].quantity) + "x" + " " + String(describing: CheckoutCart.shared.cart[indexPath.row].name!))"
        cell.drinkImageView.image = UIImage(named: CheckoutCart.shared.cart[indexPath.row].name!.lowercased())
        cell.cost.text = "$" + String(CheckoutCart.shared.cart[indexPath.row].cost)
        return cell
    }
}
