//
//  STPAddressFieldTableViewCell.swift
//  Stripe
//
//  Created by Ben Guo on 4/13/16.
//  Copyright © 2016 Stripe, Inc. All rights reserved.
//

import UIKit

enum STPAddressFieldType: Int {
    case name
    case line1
    case line2
    case city
    case state
    case zip
    case country
    case email
    case phone
}

protocol STPAddressFieldTableViewCellDelegate: class {
    func addressFieldTableViewCellDidUpdateText(_ cell: STPAddressFieldTableViewCell)

    func addressFieldTableViewCellDidReturn(_ cell: STPAddressFieldTableViewCell)
    func addressFieldTableViewCellDidEndEditing(_ cell: STPAddressFieldTableViewCell)
    var addressFieldTableViewCountryCode: String? { get set }
    var availableCountries: Set<String>? { get set }
}

class STPAddressFieldTableViewCell: UITableViewCell, UITextFieldDelegate, UIPickerViewDelegate,
    UIPickerViewDataSource
{
    init(
        type: STPAddressFieldType,
        contents: String?,
        lastInList: Bool,
        delegate: STPAddressFieldTableViewCellDelegate?
    ) {
        textField = {
            if type == .phone {
                // We have very specific US-based phone formatting that's built into STPFormTextField
                let formTextField = STPFormTextField()
                formTextField.preservesContentsOnPaste = false
                formTextField.selectionEnabled = false
                return formTextField
            } else {
                return STPValidatedTextField()
            }
        }()

        super.init(style: .default, reuseIdentifier: nil)
        self.delegate = delegate
        theme = STPTheme()
        _contents = contents

        textField.delegate = self
        textField.addTarget(
            self,
            action: #selector(STPAddressFieldTableViewCell.textFieldTextDidChange(textField:)),
            for: .editingChanged
        )
        contentView.addSubview(textField)

        let toolbar = UIToolbar()
        let flexibleItem = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let nextItem = UIBarButtonItem(
            title: STPLocalizedString("Next", nil),
            style: .done,
            target: self,
            action: #selector(nextTapped(sender:))
        )
        toolbar.items = [flexibleItem, nextItem]
        inputAccessoryToolbar = toolbar

        var countryCode = NSLocale.autoupdatingCurrent.regionCode
        var otherCountryCodes = Array(
            self.delegate?.availableCountries ?? Set(NSLocale.isoCountryCodes))
        if otherCountryCodes.contains(countryCode ?? "") {
            // Remove the current country code to re-add it once we sort the list.
            otherCountryCodes.removeAll { $0 == countryCode }
        } else {
            // If it isn't in the list (if we've been configured to not show that country), don't re-add it.
            countryCode = nil
        }
        let locale = NSLocale.current as NSLocale
        otherCountryCodes =
            (otherCountryCodes as NSArray).sortedArray(comparator: { code1, code2 in
                guard let code1 = code1 as? String, let code2 = code2 as? String else {
                    return .orderedDescending
                }
                let localeID1 = NSLocale.localeIdentifier(fromComponents: [
                    NSLocale.Key.countryCode.rawValue: code1,
                ])
                let localeID2 = NSLocale.localeIdentifier(fromComponents: [
                    NSLocale.Key.countryCode.rawValue: code2,
                ])
                if let name1 = locale.displayName(forKey: .identifier, value: localeID1),
                   let name2 = locale.displayName(forKey: .identifier, value: localeID2)
                {
                    return name1.compare(name2)
                } else {
                    return .orderedDescending
                }
            }) as? [String] ?? []
        if let countryCode = countryCode {
            countryCodes = ["", countryCode] + otherCountryCodes
        } else {
            countryCodes = [""] + otherCountryCodes
        }
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        countryPickerView = pickerView

        self.lastInList = lastInList
        self.type = type
        textField.text = contents

        var ourCountryCode = self.delegate?.addressFieldTableViewCountryCode

        if ourCountryCode == nil {
            ourCountryCode = countryCode
        }
        delegateCountryCodeDidChange(countryCode: ourCountryCode ?? "")
        updateAppearance()

        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                textField.leadingAnchor.constraint(
                    equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 15
                ),
                textField.trailingAnchor.constraint(
                    equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -15
                ),
                textField.topAnchor.constraint(
                    equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 1
                ),
                contentView.safeAreaLayoutGuide.bottomAnchor.constraint(
                    greaterThanOrEqualTo: textField.bottomAnchor),
                textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 43),
                inputAccessoryToolbar?.heightAnchor.constraint(equalToConstant: 44),
            ].compactMap { $0 })
    }

    var type: STPAddressFieldType = .name
    var caption: String? {
        get {
            textField.placeholder
        }
        set {
            textField.placeholder = newValue
        }
    }

    private(set) var textField: STPValidatedTextField
    private var _contents: String?
    var contents: String? {
        get {
            // iOS 11 QuickType completions from textContentType have a space at the end.
            // This *keeps* that space in the `textField`, but removes leading/trailing spaces from
            // the logical contents of this field, so they're ignored for validation and persisting
            return _contents?.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        set {
            _contents = newValue
            if type == .country {
                updateTextFieldsAndCaptions()
            } else {
                textField.text = contents
            }
            if textField.isFirstResponder {
                textField.validText = potentiallyValidContents
            } else {
                textField.validText = validContents
            }
            delegate?.addressFieldTableViewCellDidUpdateText(self)
        }
    }

    var theme: STPTheme = .defaultTheme {
        didSet {
            updateAppearance()
        }
    }

    var lastInList: Bool = false {
        didSet {
            updateTextFieldsAndCaptions()
        }
    }

    private var inputAccessoryToolbar: UIToolbar?
    private var countryPickerView: UIPickerView?
    private var countryCodes: [AnyHashable]?
    private weak var delegate: STPAddressFieldTableViewCellDelegate?
    private var ourCountryCode: String?

    func updateTextFieldsAndCaptions() {
        textField.placeholder = placeholder(for: type)

        if !lastInList {
            textField.returnKeyType = .next
        } else {
            textField.returnKeyType = .default
        }
        switch type {
        case .name:
            textField.keyboardType = .default
            textField.textContentType = .name
        case .line1:
            textField.keyboardType = .numbersAndPunctuation
            textField.textContentType = .streetAddressLine1
        case .line2:
            textField.keyboardType = .numbersAndPunctuation
            textField.textContentType = .streetAddressLine2
        case .city:
            textField.keyboardType = .default
            textField.textContentType = .addressCity
        case .state:
            textField.keyboardType = .default
            textField.textContentType = .addressState
        case .zip:
            textField.keyboardType = .numbersAndPunctuation
            textField.textContentType = .postalCode
        case .country:
            textField.keyboardType = .default
            // Don't set textContentType for Country, because we don't want iOS to skip the UIPickerView for input
            textField.inputView = countryPickerView
            // If we're being set directly to a country we don't allow, add it to the allowed list
            let countryCodes = self.countryCodes ?? []
            if let contents = contents,
               !countryCodes.contains(contents), NSLocale.isoCountryCodes.contains(contents)
            {
                self.countryCodes = countryCodes + [contents]
            }
            let index = countryCodes.firstIndex(of: contents ?? "") ?? NSNotFound
            if index == NSNotFound {
                textField.text = ""
            } else {
                countryPickerView?.selectRow(index, inComponent: 0, animated: false)
                if let countryPickerView = countryPickerView {
                    textField.text = pickerView(countryPickerView, titleForRow: index, forComponent: 0)
                }
            }
            textField.validText = validContents
        case .phone:
            textField.keyboardType = .numbersAndPunctuation
            textField.textContentType = .telephoneNumber
            let behavior: STPFormTextFieldAutoFormattingBehavior =
                (countryCodeIsUnitedStates ? .phoneNumbers : .none)
            (textField as? STPFormTextField)?.autoFormattingBehavior = behavior
        case .email:
            textField.keyboardType = .emailAddress
            textField.textContentType = .emailAddress
        }

        if !lastInList {
            textField.inputAccessoryView = inputAccessoryToolbar
        } else {
            textField.inputAccessoryView = nil
        }
        textField.accessibilityLabel = textField.placeholder
        textField.accessibilityIdentifier = accessibilityIdentifierForAddressField(
            type: type)
    }

    func accessibilityIdentifierForAddressField(type: STPAddressFieldType) -> String {
        switch type {
        case .name:
            return "ShippingAddressFieldTypeNameIdentifier"
        case .line1:
            return "ShippingAddressFieldTypeLine1Identifier"
        case .line2:
            return "ShippingAddressFieldTypeLine2Identifier"
        case .city:
            return "ShippingAddressFieldTypeCityIdentifier"
        case .state:
            return "ShippingAddressFieldTypeStateIdentifier"
        case .zip:
            return "ShippingAddressFieldTypeZipIdentifier"
        case .country:
            return "ShippingAddressFieldTypeCountryIdentifier"
        case .email:
            return "ShippingAddressFieldTypeEmailIdentifier"
        case .phone:
            return "ShippingAddressFieldTypePhoneIdentifier"
        }
    }

    func stateFieldCaption(forCountryCode countryCode: String?) -> String {
        switch countryCode {
        case "US":
            return STPLocalizedString(
                "State",
                "Caption for State field on address form (only countries that use state , like United States)"
            )
        case "CA":
            return STPLocalizedString(
                "Province",
                "Caption for Province field on address form (only countries that use province, like Canada)"
            )
        case "GB":
            return STPLocalizedString(
                "County",
                "Caption for County field on address form (only countries that use county, like United Kingdom)"
            )
        default:
            return STPLocalizedString(
                "State / Province / Region",
                "Caption for generalized state/province/region field on address form (not tied to a specific country's format)"
            )
        }
    }

    func placeholder(for addressFieldType: STPAddressFieldType) -> String {
        switch addressFieldType {
        case .name:
            return STPLocalizationUtils.localizedNameString()
        case .line1:
            return STPLocalizedString("Address", "Caption for Address field on address form")
        case .line2:
            return STPLocalizedString(
                "Apt.", "Caption for Apartment/Address line 2 field on address form"
            )
        case .city:
            return STPLocalizedString("City", "Caption for City field on address form")
        case .state:
            return stateFieldCaption(forCountryCode: ourCountryCode)
        case .zip:
            return countryCodeIsUnitedStates
                ? STPLocalizedString(
                    "ZIP Code",
                    "Caption for Zip Code field on address form (only shown when country is United States only)"
                )
                : STPLocalizedString(
                    "Postal Code",
                    "Caption for Postal Code field on address form (only shown in countries other than the United States)"
                )
        case .country:
            return STPLocalizedString("Country", "Caption for Country field on address form")
        case .email:
            return STPLocalizationUtils.localizedEmailString()
        case .phone:
            return STPLocalizedString("Phone", "Caption for Phone field on address form")
        }
    }

    func delegateCountryCodeDidChange(countryCode: String) {
        if type == .country {
            contents = countryCode
        }

        ourCountryCode = countryCode
        updateTextFieldsAndCaptions()
        setNeedsLayout()
    }

    func updateAppearance() {
        backgroundColor = theme.secondaryBackgroundColor
        contentView.backgroundColor = .clear
        textField.placeholderColor = theme.tertiaryForegroundColor
        textField.defaultColor = theme.primaryForegroundColor
        textField.errorColor = theme.errorColor
        textField.font = theme.font
        setNeedsLayout()
    }

    var countryCodeIsUnitedStates: Bool {
        self.ourCountryCode == "US"
    }

    override public func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    @objc func nextTapped(sender _: NSObject) {
        delegate?.addressFieldTableViewCellDidReturn(self)
    }

    @objc
    public func textFieldShouldReturn(_: UITextField) -> Bool {
        delegate?.addressFieldTableViewCellDidReturn(self)
        return false
    }

    @objc
    public func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? STPFormTextField)?.validText = validContents
        delegate?.addressFieldTableViewCellDidEndEditing(self)
    }

    override public func accessibilityElementCount() -> Int {
        return 1
    }

    override public func accessibilityElement(at _: Int) -> Any? {
        return textField
    }

    override public func index(ofAccessibilityElement _: Any) -> Int {
        return 0
    }

    @objc func textFieldTextDidChange(textField: STPValidatedTextField) {
        if type != .country {
            _contents = textField.text
            if textField.isFirstResponder {
                textField.validText = potentiallyValidContents
            } else {
                textField.validText = validContents
            }
        }
        delegate?.addressFieldTableViewCellDidUpdateText(self)
    }

    // pragma mark - UITextFieldDelegate

    var validContents: Bool {
        switch type {
        case .name, .line1, .city, .state, .country:
            return contents?.count ?? 0 > 0
        case .line2:
            return true
        case .zip:
            return STPPostalCodeValidator.validationState(
                forPostalCode: contents, countryCode: ourCountryCode
            ) == .valid
        case .email:
            return STPEmailAddressValidator.stringIsValidEmailAddress(contents)
        case .phone:
            return STPPhoneNumberValidator.stringIsValidPhoneNumber(
                contents ?? "", forCountryCode: ourCountryCode
            )
        }
    }

    var potentiallyValidContents: Bool {
        switch type {
        case .name, .line1, .city, .state, .country, .line2:
            return true
        case .zip:
            let validationState = STPPostalCodeValidator.validationState(
                forPostalCode: contents, countryCode: ourCountryCode
            )
            return validationState == .valid || validationState == .incomplete
        case .email:
            return STPEmailAddressValidator.stringIsValidPartialEmailAddress(contents)
        case .phone:
            return STPPhoneNumberValidator.stringIsValidPartialPhoneNumber(
                contents ?? "", forCountryCode: ourCountryCode
            )
        }
    }

    public func pickerView(
        _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int
    ) {
        guard let countryCode = countryCodes?[row] as? String
        else {
            return
        }
        ourCountryCode = countryCode
        contents = ourCountryCode
        textField.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        textFieldTextDidChange(textField: textField) // UIControlEvent not fired for programmatic changes
        delegate?.addressFieldTableViewCountryCode = ourCountryCode ?? ""
    }

    public func pickerView(
        _: UIPickerView, titleForRow row: Int, forComponent _: Int
    ) -> String? {
        guard let countryCode = countryCodes?[row] as? String else {
            return nil
        }
        let identifier = Locale.identifier(fromComponents: [
            NSLocale.Key.countryCode.rawValue: countryCode,
        ])
        return (NSLocale.autoupdatingCurrent as NSLocale).displayName(
            forKey: NSLocale.Key(rawValue: NSLocale.Key.identifier.rawValue), value: identifier
        )
    }

    public func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        countryCodes?.count ?? 0
    }

    required convenience init?(coder _: NSCoder) {
        assertionFailure("Use initWithType: instead.")
        self.init(type: .name,
                  contents: nil,
                  lastInList: false,
                  delegate: nil)
    }
}
