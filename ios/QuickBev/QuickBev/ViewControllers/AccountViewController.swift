//
//  AccountViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 7/12/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @UsesAutoLayout var tableView = UITableView()
    @UsesAutoLayout var logoImageView = UIImageView.LogoImageView

    let accountOptions = ["Edit Profile", "Manage Payment Methods", "Customer Support", "Settings", "Legal", "Sign Out"]

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
        // add the table view to self.view
        view.addSubview(logoImageView)
        view.addSubview(tableView)
        tableView.backgroundColor = .clear

        let safeArea = view.safeAreaLayoutGuide
        //        let frame = self.view.safeAreaLayoutGuide.layoutFrame
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: CGFloat(0.565217)),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

            logoImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0.02 * UIViewController.screenSize.height),

            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 140.0 / UIViewController.screenSize.height),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0),
        ])

        // set delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        // register a defalut cell
        tableView.register(AccountTableViewCell.self, forCellReuseIdentifier: "cell")
        // to get rid of default grey lines that border cells in UITableView
        tableView.separatorColor = UIColor.clear
    }

    // Note: because this is NOT a subclassed UITableViewController,
    // DataSource and Delegate functions are NOT overridden

    // MARK: - Table view data source

    // this is for custom UITableView Cell Seperators
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let placeCell = cell as? AccountTableViewCell {
            placeCell.render(position: indexPath.row, total: accountOptions.count)
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        // custom height- TODO: set this based on screen size
        return 50
    }

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return accountOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AccountTableViewCell
        cell.myLabel.text = "\(accountOptions[indexPath.row])"
        cell.selectionStyle = .none
        return cell
    }

    // MARK: - Table view delegate

    private func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Log Out", style: .default) { _ in
            // delete the current shopping cart
            DispatchQueue.main.async {
                // need to delete the existing CheckoutCart due to singleton architecture, and to reset stripe values
                CoreDataManager.sharedManager.deleteEntities(entityName: "CheckoutCart")
                CoreDataManager.sharedManager.deleteEntities(entityName: "User")
                CoreDataManager.sharedManager.saveContext()
            }
            SceneDelegate.shared.rootViewController.switchToSplashPageViewController()
        }
        logoutAction.setValue(UIColor.red, forKey: "titleTextColor")
        alertController.addAction(logoutAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true)
        })
        present(alertController, animated: true) {}
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAccountOption = accountOptions[indexPath.row]
        if selectedAccountOption == "Sign Out" {
            alert(title: "Log out of \(String(describing: CheckoutCart.shared.user!.email))?", message: "")
        }
        // etc
    }
}
