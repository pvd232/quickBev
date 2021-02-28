//
//  OrderTableViewCell.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 4/18/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit
class OrderTableViewCell: UITableViewCell {
    @IBOutlet var orderNumber: UILabel!
    @IBOutlet var orderPrice: UILabel!
    var order: Order?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
