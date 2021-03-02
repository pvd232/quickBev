//
//  OrderConfirmationViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 1/7/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    @UsesAutoLayout var pickupDetailsStackView = UIStackView()
    @UsesAutoLayout var pickupDetailsLabel = UILabel(theme: Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var pickupAddressLabel = UILabel(theme: Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var businessNameLabel = UILabel(theme: Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var addressLabel = UILabel(theme: Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var pickupInstructionsLabel = UILabel(theme: Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var pickupInstructionsText = UILabel(theme: Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var toolbarView = ToolbarView()
    var didLayoutBadgeNotification = false

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("coder not set up")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(pickupDetailsStackView)
        view.addSubview(toolbarView)
        pickupDetailsStackView.addArrangedSubview(pickupDetailsLabel)
        pickupDetailsStackView.addArrangedSubview(pickupAddressLabel)
        pickupDetailsStackView.addArrangedSubview(businessNameLabel)
        pickupDetailsStackView.addArrangedSubview(addressLabel)
        pickupDetailsStackView.addArrangedSubview(pickupInstructionsLabel)
        pickupDetailsStackView.addArrangedSubview(pickupInstructionsText)

        pickupDetailsStackView.axis = .vertical
        pickupDetailsStackView.spacing = 20

        pickupDetailsLabel.text = "Pickup details"
        pickupDetailsLabel.font = UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 40.0))

        pickupAddressLabel.text = "Pickup address"
        pickupAddressLabel.font = UIFont(name: "Charter-Black", size: calculateFontRatio(fontSize: 20.0))

        businessNameLabel.text = "Business Name"
        businessNameLabel.font = UIFont.themeLabelFont

        addressLabel.text = "Address"
        addressLabel.font = UIFont.themeLabelFont

        pickupInstructionsLabel.text = "Pickup instructions"
        pickupInstructionsLabel.font = UIFont(name: "Charter-Black", size: calculateFontRatio(fontSize: 20.0))

        pickupInstructionsText.text = "Go to the second floor to the end of the business and tell business your name"
        pickupInstructionsText.font = UIFont.themeLabelFont

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            pickupDetailsStackView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            pickupDetailsStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            pickupDetailsStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            toolbarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
            toolbarView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            toolbarView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            toolbarView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.12),
        ])
    }

    override func viewDidAppear(_: Bool) {
        didLayoutBadgeNotification = true
    }

    override func viewDidLayoutSubviews() {
        if didLayoutBadgeNotification == false {
            toolbarView.hub!.moveCircleBy(x: toolbarView.orderButton.frame.width, y: CGFloat(-4.0))
        }
    }

    override func viewWillAppear(_: Bool) {
        toolbarView.hub!.setCount(CheckoutCart.shared.cart.count)
    }
}
