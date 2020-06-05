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
    
    var drinks: [Drink] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select Drink"
        fetchInventory { drinks in
            guard drinks != nil else { return }
            self.drinks = drinks!
            self.tableView.reloadData()
        }
    }
    private func fetchInventory(completion: @escaping ([Drink]?) -> Void) {
        AF.request("http://127.0.0.1:5000/inventory", method: .get)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    os_log("Successful API Inventory Call")
                    guard let rawInventory = response.value as? [[String: Any]?]
                        else {
                            os_log("failure to capture data")
                            return completion(nil)
                    }
                    let inventory = rawInventory.compactMap{ drinkDict -> Drink? in var data = drinkDict!
                    
                        //                        data["image"] = UIImage(named: drinkDict!["image"] as! String)
                        
                        return Drink(data: data as! [String : String])
                    }
                    completion(inventory)
                case .failure(let error):
                    completion(nil)
                    print(error)
                    
                }
        }
    }
    
    @IBAction func ordersButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "Orders", sender: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> DrinkTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Drink", for: indexPath) as! DrinkTableViewCell
        cell.name.text = drinks[indexPath.row].name
        cell.imageView?.image = UIImage(named: drinks[indexPath.row].name.lowercased())
        //https://stackoverflow.com/questions/50479772/how-to-convert-nsnumber-to-string-in-swift4
        cell.price.text = drinks[indexPath.row].price
        cell.miscellaneousText.text = drinks[indexPath.row].description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DrinkDetail"){
            guard let drinkDetailViewController = segue.destination as?
                DrinkViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedDrinkCell = sender as? DrinkTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedDrinkCell) else {
                fatalError("The selected cell is not being displated by the table")
            }
            
            let selectedDrink = drinks[indexPath.row]
            drinkDetailViewController.drink = selectedDrink
        }
    }
}
