//
//  AccountTableViewCell.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 8/6/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    let myLabel = UILabel(theme: Theme.UILabel(props: [.textColor]))
    let mySeparator = UIView()
    var path: UIBezierPath!
    let strokeColor = UIColor.lightGray.cgColor
    let sLayer = CAShapeLayer()

    private func updateShapeLayer() {
        sLayer.path = path.cgPath
    }

    func render(position _: Int, total: Int) {
        // Each cell will start with its own fresh, discrete path
        path = UIBezierPath()
        drawFirstPath(path, total: total)
        updateShapeLayer()
    }

    private func drawFirstPath(_ path: UIBezierPath, total _: Int) {
        let width = frame.size.width
        let height = frame.size.height

        path.move(to: CGPoint(x: 0.0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        sLayer.strokeColor = strokeColor
        sLayer.lineWidth = 1.5
        sLayer.strokeEnd = 1.0
        // first number is the # of filled dashes, second number is # of empty dashes
        sLayer.lineDashPattern = [5, 7]

        layer.addSublayer(sLayer)
        mySeparator.translatesAutoresizingMaskIntoConstraints = false
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mySeparator)
        contentView.addSubview(myLabel)

        let views = [
            "contentView": contentView,
            "label": myLabel,
            "separator": mySeparator,
        ]

        // https://medium.com/@Cordavi/exploring-visual-format-language-with-swift-7ba2c1f4c924

        var allConstraints = [NSLayoutConstraint]()
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat:
            "V:|-[label]-[separator(2)]|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat:
            "H:|-[label]-|", options: [], metrics: nil, views: views)
        allConstraints += NSLayoutConstraint.constraints(withVisualFormat:
            "H:|-[separator]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(allConstraints)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
