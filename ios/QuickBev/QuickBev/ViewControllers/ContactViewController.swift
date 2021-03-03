//
//  ContactViewController.swift
//  QuickBev
//
//  Created by Peter Vail Driscoll II on 3/3/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
import UIKit
class ContactViewController: UIViewController {
    @UsesAutoLayout var contactUsStackView = UIStackView()
    @UsesAutoLayout var emailUsLabel = UILabel(theme: Theme.UILabel(props: [.textColor, .font(UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 19.458))!)]))
    @UsesAutoLayout var contactUsLabel = UILabel(theme: Theme.UILabel(props: [.textColor]))
    @UsesAutoLayout var goToOurWebsiteLabel = UILabel(theme: Theme.UILabel(props: [.font(UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 19.458))), .textColor]))

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("coder not set up")
    }

    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(contactUsStackView)
        contactUsStackView.addArrangedSubview(contactUsLabel)
        contactUsStackView.addArrangedSubview(emailUsLabel)
        contactUsStackView.addArrangedSubview(goToOurWebsiteLabel)
        contactUsStackView.axis = .vertical
        contactUsStackView.spacing = 40

        contactUsLabel.text = "Contact us"
        contactUsLabel.font = UIFont(name: "Charter-Roman", size: calculateFontRatio(fontSize: 40.0))
        let confirmationEmailString = attributedText(withString: "Email us with any questions or concerns at quickbev@gmail.com", boldString: "quickbev@gmail.com", font: emailUsLabel.font)
        emailUsLabel.attributedText = confirmationEmailString
        emailUsLabel.numberOfLines = 0
        emailUsLabel.lineBreakMode = .byWordWrapping

        let resendConfirmationEmailString = attributedText(withString: "You can also get more information about us at our website www.quickbev.com", boldString: "www.quickbev.com", font: goToOurWebsiteLabel.font)
        goToOurWebsiteLabel.attributedText = resendConfirmationEmailString
        goToOurWebsiteLabel.numberOfLines = 0
        goToOurWebsiteLabel.lineBreakMode = .byWordWrapping

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            contactUsStackView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.9),
            contactUsStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: UIViewController.screenSize.height * 0.1),
            contactUsStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
        ])
    }
}
