//
//  ViewController.swift
//  ASContacts
//
//  Created by Anton Stremovskiy on 6/9/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import UIKit
import Contacts


class ContactsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var dispatchItem: DispatchWorkItem?
    
    var category = [String]()
    var contacts = [Contact]() {
        didSet {
            category = Array(Set(self.contacts.map { String($0.firstName.substring(to: 1)) })).sorted
                { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            tableView.reloadData()
        }
    }
    
    // MARK: - Settings
    public static var navBarTintColor = UIColor.coolBlue
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ContactsData().getContactsAccess(success: { (success) in
            self.contacts = ContactsData().getAllContacts()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func setupController() {
        
        title = "Contact list"
        
        let closeButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ContactsViewController.close))
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ContactsViewController.done))
        
        doneButton.tintColor = UIColor.white
        closeButton.tintColor = UIColor.white
        
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = doneButton
        
        navigationController?.navigationBar.barTintColor = ContactsViewController.navBarTintColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue:UIColor.white]
    }
    
    @objc private func close() {
        print("closing...")
        //dismiss(animated: true, completion: nil)
    }
    
    @objc private func done() {
        print("selected...")
        //dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName:"ContactCell", bundle: nil), forCellReuseIdentifier: "contact")
        tableView.tableFooterView = UIView()
        tableView.prefetchDataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionIndexColor = UIColor.darkGray
        tableView.sectionIndexBackgroundColor = UIColor.lightText
        tableView.setContentOffset(CGPoint(x: 0, y: searchBar.frame.size.height), animated: false)
    }
    
}

extension ContactsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return contacts.filter { $0.firstName.substring(to: 1) == category[section] }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath) as! ContactCell
        
        let contact = contacts.filter { $0.firstName.substring(to: 1) == category[indexPath.section]}[indexPath.row]
        
        cell.fullName.text = "\(contact.firstName) \(contact.lastName)"
        cell.phoneNumber.text = contact.phones.first
        cell.profileImage.image = contact.thumb
        
        return cell
    }
}

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return category[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return category
    }
   
    
}

extension ContactsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("prefetching following indexes: \(indexPaths)")
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("cancel prefetching following indexes: \(indexPaths)")
    }
}

extension ContactsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range.length + range.location > 0 {
            let filteredContacts = contacts.filter { ($0.firstName.contains(text) || $0.lastName.contains(text)) }
            contacts = filteredContacts
            
        } else {
            contacts = ContactsData().getAllContacts()
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            contacts = ContactsData().getAllContacts()
        }
    }
    
}







