//
//  OrderTableViewCell.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 4/18/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
class OrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    var order: Order?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
