//
//  DrinkTableViewCell.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 3/29/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class DrinkTableViewCell: UITableViewCell {
    
    @UsesAutoLayout var drinkImageView = UIImageView()
    @UsesAutoLayout var name = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var miscellaneousText = UILabel(theme:Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var stackView = UIStackView()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(drinkImageView)
        self.backgroundColor = .clear
        
        let margins = self.contentView.safeAreaLayoutGuide
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(miscellaneousText)
        stackView.spacing = 10
        
        self.contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            drinkImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10),
            drinkImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10),
            drinkImageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -10),
            drinkImageView.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.2),
            stackView.leadingAnchor.constraint(equalTo: drinkImageView.trailingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10)
        ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
