//
//  BusinessArrayViewController.swift
//  Drinkz
//
//  Created by Peter Vail Driscoll II on 12/17/20.
//  Copyright © 2020 Peter Vail Driscoll II. All rights reserved.
//

import UIKit

protocol BusinessPickerProtocol {
    func selectedBusinessHandler(_ selectedBusiness: Business)
}

class BusinessArrayViewController: UIViewController, UIGestureRecognizerDelegate {
    let tableView = UITableView()
    var filteredBusinesses = [Business]()
    let searchController = UISearchController(searchResultsController: nil)

    var businessPickerDelegate: BusinessPickerProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchField: UITextField? = searchController.searchBar.value(forKey: "searchField") as? UITextField
        searchField?.backgroundColor = UIColor.white
        navigationController?.view.layoutIfNeeded()
        navigationController?.view.setNeedsLayout()

        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search our partner venues"

        // 4
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        // 5

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let margins = view.safeAreaLayoutGuide
        tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.register(BusinessArrayTableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func viewWillAppear(_: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    override func viewWillDisappear(_: Bool) {
        navigationController?.navigationBar.isHidden = true
        tableView.isHidden = true
        navigationItem.searchController?.isActive = false
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredBusinesses = CheckoutCart.shared.businessArray.filter { (business: Business) -> Bool in
            for (letter1, letter2) in zip(searchText.lowercased(), business.name!.lowercased()) {
                if letter1 != letter2 {
                    return false
                }
            }
            return true
        }
        tableView.reloadData()
    }

    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
}

extension BusinessArrayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        // custom height- TODO: set this based on screen size
        return 80
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if isFiltering {
            return filteredBusinesses.count
        }
        return CheckoutCart.shared.businessArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BusinessArrayTableViewCell
        let business: Business
        if isFiltering {
            business = filteredBusinesses[indexPath.row]
        } else {
            business = CheckoutCart.shared.businessArray[indexPath.row]
        }
        cell.name.text = "\(business.name!)"
        cell.address.text = "\(business.address!)"
        return cell
    }

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBusiness: Business
        if isFiltering {
            selectedBusiness = filteredBusinesses[indexPath.row]
        } else {
            selectedBusiness = CheckoutCart.shared.businessArray[indexPath.row]
        }
        businessPickerDelegate.selectedBusinessHandler(selectedBusiness)
        let transition = CATransition()
        transition.duration = 0.65
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        navigationController!.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: true)
    }
}

extension BusinessArrayViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
