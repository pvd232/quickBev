//
//  TabCreationViewController2.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 12/21/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

protocol TabCreationSecondPagePickerProtocol {
    func selectedValues (_ selectedValues:String)
}
class TabCreationViewController2: UIViewController {
    
    @IBOutlet weak var submitButton: RoundButton!
    @IBOutlet weak var eventPrivacySegmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        eventPrivacySegmentedControl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(eventPrivacyEventHandler)))
        
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Charter-Roman", size: 20)!]
        self.navigationController!.navigationBar.standardAppearance.titleTextAttributes  = attributes
    }
    
    @objc func eventPrivacyEventHandler () {
        print("eventPrivacySegmentedControl.selectedSegmentIndex",eventPrivacySegmentedControl.selectedSegmentIndex)
    }
}
