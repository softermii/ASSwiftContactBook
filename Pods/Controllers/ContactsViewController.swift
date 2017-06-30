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

enum SubtitleType {
    case email
    case phone
    case birthday
    case organization
    case job
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
    
    
    // MARK: - Settings
    static public var barColor = UIColor.coolBlue
    static public var indexColor = UIColor.coolBlue
    static public var indexBackgroundColor = UIColor.lightText
    static public var cancelButtonTittle = "Cancel"
    static public var doneButtonTittle = "Done"
    static public var mainTitle = "Contacts"
    static public var subtitleType = SubtitleType.phone

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupController()
        initButtons()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        fetchContacts()
    }
    
    convenience public init(delegate: ASContactBookPickerDelegate) {
        self.init(nibName: "ContactsViewController", bundle: nil)
        contactPickerDelegate = delegate
    }
    
    convenience public init(delegate: ASContactBookPickerDelegate, subTitle: SubtitleType) {
        self.init(nibName: "ContactsViewController", bundle: nil)
        contactPickerDelegate = delegate
        ContactsViewController.subtitleType = subTitle
    }
    
    private func fetchContacts() {
        ContactsData().getContactsAccess(success: { (success) in
            self.contacts = ContactsData().getAllContacts()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func setupController() {
        title = ContactsViewController.mainTitle
        navigationController?.navigationBar.barTintColor = ContactsViewController.barColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    fileprivate func initButtons() {
        
        let closeButton = UIBarButtonItem(title: ContactsViewController.cancelButtonTittle, style: .plain, target: self, action: #selector(ContactsViewController.close))
        closeButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = closeButton
        
        doneButton = UIBarButtonItem(title: ContactsViewController.doneButtonTittle, style: .plain, target: self, action: #selector(ContactsViewController.done))
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
        tableView.setContentOffset(CGPoint(x: 0, y: searchBar.frame.size.height), animated: false)
        tableView.sectionIndexColor = ContactsViewController.indexColor
        tableView.sectionIndexBackgroundColor = ContactsViewController.indexBackgroundColor
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
        cell.setupCell(contact: contact, subtitleType: ContactsViewController.subtitleType)

        return cell
    }
}

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! ContactCell
        guard let contact = cell.contactData else { return }
        
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








