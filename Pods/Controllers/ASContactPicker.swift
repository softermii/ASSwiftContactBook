//
//  ViewController.swift
//  ASContacts
//
//  Created by Anton Stremovskiy on 6/9/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import UIKit
import Contacts


enum SubtitleType {
    case email
    case phone
    case birthday
    case organization
    case job
}



class ASContactPicker: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var doneButton: UIBarButtonItem!
    
    public var didSelectContacts: ((_ selectedContacts: [Contact]) -> Void)? = nil
    
    var category = [String]()
    
    var contacts = [Contact]() {
        didSet {
            category = Array(Set(self.contacts.map { String($0.firstName.substring(to: 1).uppercased() ) })).sorted
                { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
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
    
    convenience public init() {
        self.init(nibName: "ASContactPicker", bundle: nil)
    }
    
    convenience public init(subTitle: SubtitleType) {
        self.init(nibName: "ASContactPicker", bundle: nil)
        ASContactPicker.subtitleType = subTitle
    }
    
    private func fetchContacts() {
        ContactsData().getContactsAccess(success: { (success) in
            self.contacts = ContactsData().getAllContacts()
        }) { (error) in
            debugPrint(error.localizedDescription)
        }
    }
    
    private func setupController() {
        title = ASContactPicker.mainTitle
        navigationController?.navigationBar.barTintColor = ASContactPicker.barColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    fileprivate func initButtons() {
        
        let closeButton = UIBarButtonItem(title: ASContactPicker.cancelButtonTittle, style: .plain, target: self, action: #selector(ASContactPicker.close))
        closeButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = closeButton
        
        doneButton = UIBarButtonItem(title: ASContactPicker.doneButtonTittle, style: .plain, target: self, action: #selector(ASContactPicker.done))
        doneButton.tintColor = UIColor.white
        doneButton.isEnabled = false
        navigationItem.rightBarButtonItem = doneButton
    }
    
    
    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func done() {
        self.dismiss(animated: true) {
            self.didSelectContacts?(self.selectedContacts)
        }
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName:"ContactCell", bundle: nil), forCellReuseIdentifier: "contact")
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.setContentOffset(CGPoint(x: 0, y: searchBar.frame.size.height), animated: false)
        tableView.sectionIndexColor = ASContactPicker.indexColor
        tableView.sectionIndexBackgroundColor = ASContactPicker.indexBackgroundColor
    }
    
}

extension ASContactPicker: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return contacts.filter { $0.firstName.substring(to: 1) == category[section] }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath) as! ContactCell
        let contact = contacts.filter { $0.firstName.substring(to: 1) == category[indexPath.section]}[indexPath.row]
        cell.setupCell(contact: contact, subtitleType: ASContactPicker.subtitleType)

        return cell
    }
}

extension ASContactPicker: UITableViewDelegate {
    
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


extension ASContactPicker: UISearchBarDelegate {
    
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








