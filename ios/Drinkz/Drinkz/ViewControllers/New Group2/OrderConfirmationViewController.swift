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
    @UsesAutoLayout var pickupDetailsLabel = UILabel()
    @UsesAutoLayout var pickupAddressLabel = UILabel()
    @UsesAutoLayout var businessNameLabel = UILabel()
    @UsesAutoLayout var addressLabel = UILabel()
    @UsesAutoLayout var pickupInstructionsLabel = UILabel()
    @UsesAutoLayout var pickupInstructionsText = UILabel()
    @UsesAutoLayout var toolbarView = ToolbarView()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder not set up")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(pickupDetailsStackView)
        self.view.addSubview(toolbarView)
        pickupDetailsStackView.addArrangedSubview(pickupDetailsLabel)
        pickupDetailsStackView.addArrangedSubview(pickupAddressLabel)
        pickupDetailsStackView.addArrangedSubview(businessNameLabel)
        pickupDetailsStackView.addArrangedSubview(addressLabel)
        pickupDetailsStackView.addArrangedSubview(pickupInstructionsLabel)
        pickupDetailsStackView.addArrangedSubview(pickupInstructionsText)

        pickupDetailsStackView.axis = .vertical
        pickupDetailsStackView.spacing = 20
        
        pickupDetailsLabel.text = "Pickup details"
        pickupDetailsLabel.font = UIFont.init(name: "Charter-Roman", size: 40.0)
        
        pickupAddressLabel.text = "Pickup address"
        pickupAddressLabel.font = UIFont.init(name: "Charter-Black", size: 20.0)
        
        businessNameLabel.text = "Business Name"
        businessNameLabel.font = UIFont.themeLabelFont
        
        addressLabel.text = "Address"
        addressLabel.font = UIFont.themeLabelFont
        
        pickupInstructionsLabel.text = "Pickup instructions"
        pickupInstructionsLabel.font = UIFont.init(name: "Charter-Black", size: 20.0)
        
        pickupInstructionsText.text = "Go to the second floor to the end of the business and tell business your name"
        pickupInstructionsText.font = UIFont.themeLabelFont
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            pickupDetailsStackView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            pickupDetailsStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            pickupDetailsStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            toolbarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
            toolbarView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            toolbarView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            toolbarView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.12),
        ])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
