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
    
    var drink: Drink?
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var drinkDescription: UITextView!
    @IBOutlet weak var drinkImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = drink!.name
        drinkImageView.image = UIImage(named: drink!.name.lowercased())
        drinkDescription.text = drink!.description
        amount.text = drink!.price.description
    }
    
    @IBAction func buyButtonPressed(_ sender: Any) {
        let encoder = JSONEncoder()
        var drinkArray = [Drink]()
        drinkArray.append(drink!)
        let myOrder = Order(userId: "pvd232", barId: "daef041a-2cf1-431a-941e-18b67b40783f", price: drink!.price, orderDrink: drinkArray)
        let encodedOrder = try! encoder.encode(myOrder)
        let orderDictonary = try! JSONSerialization.jsonObject(with:encodedOrder, options: []) as? [String:AnyObject]
        
        //https://stackoverflow.com/questions/31982513/how-to-send-a-post-request-with-body-in-swift?rq=1
        AF.request("http://127.0.0.1:5000/orders", method: .post, parameters: orderDictonary, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                case .success(let value):
                    print("value", value)
                    self.alertSuccess()
                case .failure (let error):
                    print(response)
                    print(error)
                    return self.alertError() }
        }
    }
    
    private func alertError() {
        return self.alert(
            title: "Purchase unsuccessful!",
            message: "Unable to complete purchase please try again later."
        )
    }
    
    private func alertSuccess() {
        return self.alert(
            title: "Purchase Successful",
            message: "You have ordered successfully, your order will be confirmed soon."
        )
    }
    private func alert(title: String, message: String) {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: "Okay", style: .cancel) { action in
            self.navigationController?.popViewController(animated: true)
        })
        present(alertCtrl, animated: true, completion: nil)
    }
}
