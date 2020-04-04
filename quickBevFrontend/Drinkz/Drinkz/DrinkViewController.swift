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
                   drinkImageView.image = drink!.image
                   drinkDescription.text = drink!.description
                   amount.text = "$\(String(describing: drink!.amount))"
        // Do any additional setup after loading the view.
    }
  
        @IBAction func buyButtonPressed(_ sender: Any) {
            let parameters = [
                "drink_id": drink!.id,
                "user_id": drink!.name
            ]
            AF.request("http://127.0.0.1:4000/orders", method: .post, parameters: parameters)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        guard let status = value as? [String: Bool],
                              let successful = status["status"] else { return self.alertError() }
                        successful ? self.alertSuccess() : self.alertError()
                    
                    case .failure (let error):
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


