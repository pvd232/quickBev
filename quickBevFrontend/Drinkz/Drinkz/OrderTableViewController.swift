//
//  OrderTableViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 4/16/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
import Alamofire
import os
class OrderTableViewController: UITableViewController {
    
//    var orders: [Order] = []
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchInventory { orders in
//            guard orders != nil else { return }
//            self.orders = orders!
//            self.tableView.reloadData()
//        }
    }
//    override func viewWillAppear(_ animated: Bool) {
//        fetchInventory{fetchedInventory in guard fetchedInventory != nil else{return}
//            self.orders = fetchedInventory!
//        }
//    }
//    private func fetchInventory(completion: @escaping ([Order]?) -> Void) {
//        AF.request("http://127.0.0.1:5000/orders", method: .get)
//            .validate()
//            .response { response in
//                switch response.result {
//                case .success:
//                    let rawInventory = response.data
//
//                    let jsonDecoder = JSONDecoder()
//                    let inventory = try! jsonDecoder.decode([Order].self, from: rawInventory!)
//
//                    self.orders = inventory
//                    completion(self.orders)
//
//                case .failure(let error):
//                    completion(nil)
//                    print(error)
//
//                }
//        }
//    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CheckoutCart.shared.cart.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        DrinkTableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "drink", for: indexPath) as! DrinkTableViewCell
//        cell.orderPrice.text = String(userOrder!.orderDrink[indexPath.row].price)
//            cell.orderNumber.text = userOrder!.orderDrink[indexPath.row].id
            return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
