//
//  DrinkTableViewCell.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 3/29/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class DrinkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var miscellaneousText: UILabel!
    @IBOutlet weak var price: UILabel!

    var drink: Drink?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
