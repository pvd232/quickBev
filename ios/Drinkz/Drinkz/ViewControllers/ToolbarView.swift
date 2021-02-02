//
//  ToolbarView.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 2/2/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

class ToolbarView: UIView {
    @UsesAutoLayout var bottomButtonsStackView = UIStackView()
    @UsesAutoLayout var centerButton = RoundButton()
    @UsesAutoLayout var orderButton = UIButton()
    @UsesAutoLayout var accountButton = UIButton()
    @UsesAutoLayout var eventsButton = UIButton()
    @UsesAutoLayout var receiptsButton = UIButton()
    
    let screenSize = UIScreen.main.bounds
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        bottomButtonsStackView.axis = .horizontal
        bottomButtonsStackView.distribution = .fillProportionally
        bottomButtonsStackView.alignment = .top
        bottomButtonsStackView.spacing = 30
        bottomButtonsStackView.addArrangedSubview(accountButton)
        bottomButtonsStackView.addArrangedSubview(receiptsButton)
        bottomButtonsStackView.addArrangedSubview(orderButton)
        bottomButtonsStackView.addArrangedSubview(eventsButton)
        
        centerButton.refreshColor(color: UIColor.themeColor)
        centerButton.titleLabel?.font = UIFont.themeButtonFont
        
        accountButton.setTitle("Account", for: .normal)
        accountButton.titleLabel?.font = UIFont.themeButtonFont
        
        eventsButton.setTitle("Events", for: .normal)
        eventsButton.titleLabel?.font = UIFont.themeButtonFont
        
        receiptsButton.setTitle("Receipts", for: .normal)
        receiptsButton.titleLabel?.font = UIFont.themeButtonFont
        
        orderButton.setTitle("Order", for: .normal)
        orderButton.titleLabel?.font = UIFont.themeButtonFont
        
        let margins = self.superView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
        bottomButtonsStackView.centerXAnchor.constraint(equalTo: bottomButtonsStackView.superview!.centerXAnchor),
        bottomButtonsStackView.heightAnchor.constraint(equalTo: bottomButtonsStackView.superview!.heightAnchor, multiplier: 0.9),
        bottomButtonsStackView.widthAnchor.constraint(equalTo: bottomButtonsStackView.superview!.widthAnchor, multiplier: 0.95),
        bottomButtonsStackView.bottomAnchor.constraint(equalTo: bottomButtonsStackView.superview!.bottomAnchor),
        
        bottomButtonsViewContainer.bottomAnchor.constraint(equalTo: bottomButtonsViewContainer.superview!.bottomAnchor, constant: 0.0),
        bottomButtonsViewContainer.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
        bottomButtonsViewContainer.topAnchor.constraint(equalTo: centerButton.bottomAnchor, constant: 134),
        bottomButtonsViewContainer.widthAnchor.constraint(equalTo: margins.widthAnchor),
        bottomButtonsViewContainer.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.12),
        )]
    }
    
}
