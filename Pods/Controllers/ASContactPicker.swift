//
//  ViewController.swift
//  ASContacts
//
//  Created by Anton Stremovskiy on 6/9/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import UIKit
import Contacts


public enum SubtitleType: String {
    case email
    case phone
    case birthday
    case organization
    case job
    case message
}

open class ASContactPicker: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var doneButton: UIBarButtonItem!
    
    public var didSelectContacts: ((_ selectedContacts: [Contact]) -> Void)? = nil
    public var didSelectSingleContact: ((_ selectedContact: Contact) -> Void)? = nil
    
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
    
    public static var barColor                = UIColor.coolBlue
    public static var indexColor              = barColor
    public static var indexBackgroundColor    = UIColor.lightText
    public static var cancelButtonTittle      = "Cancel"
    public static var doneButtonTittle        = "Done"
    public static var mainTitle               = "Contacts"
    public static var subtitleType            = SubtitleType.phone
    public static var multiSelection          = true
    public static var shouldOpenContactDetail = false
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupController()
        initButtons()
        fetchContacts()
    }
    
    convenience public init() {
        let bundle = Bundle(for: ASContactPicker.self)
        self.init(nibName: ASContactPicker.className, bundle: bundle)
    }
    
    convenience  public init(subTitle: SubtitleType, shouldOpenContactDetail: Bool = false) {
        let bundle = Bundle(for: ASContactPicker.self)
        self.init(nibName: ASContactPicker.className, bundle: bundle)
        ASContactPicker.subtitleType                 = subTitle
        ASContactPicker.shouldOpenContactDetail = shouldOpenContactDetail
    }
    
    convenience public init(subTitle: SubtitleType, multipleSelection: Bool, barColor: UIColor = .coolBlue, shouldOpenContactDetail: Bool = false) {
        let bundle = Bundle(for: ASContactPicker.self)
        self.init(nibName: ASContactPicker.className, bundle: bundle)
        ASContactPicker.subtitleType                 = subTitle
        ASContactPicker.multiSelection               = multipleSelection
        ASContactPicker.barColor     = barColor
        ASContactPicker.shouldOpenContactDetail = shouldOpenContactDetail
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
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                                   NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)]
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
        
        let bundle = Bundle(for: ASContactPicker.self)
        tableView.register(UINib(nibName: ContactCell.className, bundle: bundle), forCellReuseIdentifier: ContactCell.className)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.setContentOffset(CGPoint(x: 0, y: searchBar.frame.size.height), animated: false)
        tableView.sectionIndexColor = ASContactPicker.indexColor
        tableView.sectionIndexBackgroundColor = ASContactPicker.indexBackgroundColor
    }
    
}

extension ASContactPicker: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return category.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.filter { $0.firstName.substring(to: 1) == category[section] }.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let bundle = Bundle(for: ASContactPicker.self)

        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.className, for: indexPath) as! ContactCell
        let contact = contacts.filter { $0.firstName.substring(to: 1) == category[indexPath.section]}[indexPath.row]
        cell.setupCell(contact: contact, subtitleType: ASContactPicker.subtitleType)
        cell.contactDetail = { contact in
            let detail = ContactDetailController(nibName: ContactDetailController.className, bundle: bundle)
            detail.contact = contact
            self.show(detail, sender: self)
        }
        
        return cell
    }
    
}

extension ASContactPicker: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ContactCell
        guard let contact = cell.contactData else { return }
        
        if ASContactPicker.multiSelection {
            if !selectedContacts.contains(contact) {
                selectedContacts.append(contact)
                cell.select.image = UIImage(named: "check")
            } else {
                selectedContacts = selectedContacts.filter { $0.contactId != contact.contactId }
                cell.select.image = UIImage(named: "uncheck")
            }
        } else {
            selectedContacts = selectedContacts.filter { $0.contactId != contact.contactId }
            self.dismiss(animated: true, completion: {
                self.didSelectSingleContact?(contact)
            })
        }
        
        debugPrint("Selected \(selectedContacts.count) contacts")
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return category[section]
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return category
    }
    
    
}


extension ASContactPicker: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if range.length + range.location > 0 {
            let filteredContacts = contacts.filter { ($0.firstName.contains(text) || $0.lastName.contains(text)) }
            contacts = filteredContacts
            
        } else {
            contacts = ContactsData().getAllContacts()
        }
        return true
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            contacts = ContactsData().getAllContacts()
        }
    }
}
