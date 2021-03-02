//
//  CheckoutCartTableViewCell.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 12/23/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class CheckoutCartTableViewCell: UITableViewCell {
    @UsesAutoLayout var drinkImageView = UIImageView()
    @UsesAutoLayout var name = UILabel(theme: Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var cost = UILabel(theme: Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var stackView = UIStackView()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(drinkImageView)
        backgroundColor = .clear
        name.font = UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 22.0))
        drinkImageView.contentMode = .scaleToFill
        drinkImageView.clipsToBounds = true
        cost.font = UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 22.0))

        let safeArea = contentView.safeAreaLayoutGuide
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(cost)
        stackView.spacing = 0

        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            drinkImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            drinkImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            drinkImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
            drinkImageView.widthAnchor.constraint(equalTo: drinkImageView.superview!.widthAnchor, multiplier: 0.2),
            stackView.leadingAnchor.constraint(equalTo: drinkImageView.trailingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
            stackView.widthAnchor.constraint(equalTo: stackView.superview!.widthAnchor, multiplier: 0.6),
            name.centerYAnchor.constraint(equalTo: name.superview!.centerYAnchor),
            cost.centerYAnchor.constraint(equalTo: cost.superview!.centerYAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
