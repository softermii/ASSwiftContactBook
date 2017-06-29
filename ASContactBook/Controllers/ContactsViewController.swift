//
//  ViewController.swift
//  ASContacts
//
//  Created by Anton Stremovskiy on 6/9/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import UIKit
import Contacts


protocol ASContactBookPickerDelegate: class {
    func didSelectContacts(_: ContactsViewController, selectedContacts: [Contact])
}


class ContactsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var doneButton: UIBarButtonItem!
    open weak var contactPickerDelegate: ASContactBookPickerDelegate?
    
    var category = [String]()
    
    var contacts = [Contact]() {
        didSet {
            category = Array(Set(self.contacts.map { String($0.firstName.substring(to: 1).uppercased() ) })).sorted
                { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            print(category)
            tableView.reloadData()
        }
    }
    
    var selectedContacts = [Contact]() {
        didSet {
            doneButton.isEnabled = selectedContacts.count > 0 ? true : false
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupController()
        initButtons()
    }
    
    convenience public init(delegate: ASContactBookPickerDelegate) {
        self.init(nibName: "ContactsViewController", bundle: nil)
        contactPickerDelegate = delegate
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
        navigationController?.navigationBar.barTintColor = UIColor.coolBlue
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    fileprivate func initButtons() {
        
        let closeButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ContactsViewController.close))
        closeButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = closeButton
        
        doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ContactsViewController.done))
        doneButton.tintColor = UIColor.white
        doneButton.isEnabled = false
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func done() {
        self.dismiss(animated: true) { 
            self.contactPickerDelegate?.didSelectContacts(self, selectedContacts: self.selectedContacts)
        }
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName:"ContactCell", bundle: nil), forCellReuseIdentifier: "contact")
        tableView.tableFooterView = UIView()
        tableView.prefetchDataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionIndexColor = UIColor.darkGray
        tableView.sectionIndexBackgroundColor = UIColor.lightText
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
        cell.contact = contact
        
        return cell
    }
}

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! ContactCell
        guard let contact = cell.contact else { return }
        
        if !selectedContacts.contains(contact) {
            selectedContacts.append(contact)
            cell.accessoryType = .checkmark
        } else {
            selectedContacts = selectedContacts.filter { $0.contactId != contact.contactId }
            cell.accessoryType = .none
        }
        
        debugPrint("Selected \(selectedContacts.count) contacts")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return category[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return category
    }
   
    
}

extension ContactsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        debugPrint("prefetching following indexes: \(indexPaths)")
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        debugPrint("cancel prefetching following indexes: \(indexPaths)")
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







