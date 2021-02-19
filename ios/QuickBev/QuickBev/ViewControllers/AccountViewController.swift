//
//  AccountViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 7/12/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class AccountViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @UsesAutoLayout var tableView = UITableView()
    @UsesAutoLayout var logoImageView = UIImageView.LogoImageView

    let accountOptions = ["Edit Profile", "Manage Payment Methods", "Customer Support",  "Settings", "Legal", "Sign Out"]
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder not set up")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Charter-Roman", size: 25)!]
        self.navigationItem.standardAppearance?.titleTextAttributes = attributes
        self.navigationItem.standardAppearance?.backgroundColor = UIColor.init(red: 134/255, green: 130/255, blue: 230/255, alpha: 1.0)
    
        self.navigationItem.setHidesBackButton(false, animated: true)
        self.view.backgroundColor = .white
        // add the table view to self.view
        self.view.addSubview(logoImageView)
        self.view.addSubview(tableView)
        tableView.backgroundColor = .clear
        
        let margins = self.view.safeAreaLayoutGuide
        //        let frame = self.view.safeAreaLayoutGuide.layoutFrame
        logoImageView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.148515).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 1.0).isActive = true
        logoImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 140.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let placeCell = cell as? AccountTableViewCell {
            placeCell.render(position: indexPath.row, total: accountOptions.count)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        // custom height- TODO: set this based on screen size
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AccountTableViewCell
        cell.myLabel.text = "\(accountOptions[indexPath.row])"
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - Table view delegate
    private func alert (title: String, message: String ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let logoutAction = UIAlertAction(title:"Log Out", style: .default) { action in
            // delete the current shopping cart
            DispatchQueue.main.async {
                // need to delete the existing CheckoutCart due to singleton architecture, and to reset stripe values
                CoreDataManager.sharedManager.deleteEntities(entityName: "CheckoutCart")
                CoreDataManager.sharedManager.saveContext()
            }
            SceneDelegate.shared.rootViewController.switchToSplashPageViewController()
        }
        logoutAction.setValue(UIColor.red, forKey: "titleTextColor")
        alertController.addAction(logoutAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            self.dismiss(animated:true)
          })
        self.present(alertController, animated: true) {
            
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAccountOption = accountOptions[indexPath.row]
        if selectedAccountOption == "Sign Out" {
            alert(title:"Log out of \(String(describing: CheckoutCart.shared.user!.email!))?", message:"")
        }
        // etc
    }
}
