//
//  BusinessArrayTableViewCell.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 12/17/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class BusinessArrayTableViewCell: UITableViewCell {
    let name = UILabel(theme: Theme.UILabel(props: [.textColor]))
    let address = UILabel(theme: Theme.UILabel(props: [.textColor]))
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont(name: "Charter-Roman",
                           size: calculateFontRatio(fontSize: 20.0))
        address.translatesAutoresizingMaskIntoConstraints = false
        address.font = UIFont(name: "Charter-Roman",
                              size: calculateFontRatio(fontSize: 14.0))
        address.textColor = UIColor.lightGray

        let margins = contentView.safeAreaLayoutGuide
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(address)
        stackView.spacing = 3

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            // name.centerXAnchor.constraint(equalTo: centerXAnchor),
            // name.centerYAnchor.constraint(equalTo: centerYAnchor),
            //            drinkImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10),
            //            drinkImageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10),
            //            drinkImageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -10),
            //            drinkImageView.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.2),
            stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10),
            stackView.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.8),
            //            stackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10),
            //                    stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -10)
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
