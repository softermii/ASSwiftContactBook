//
//  ContactDetailController.swift
//  ASContactBook
//
//  Created by Anton Stremovskiy on 7/7/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import UIKit
import Foundation

protocol ContactDetailControllerDelegate: class {
    func getContact(_ contact: String)
}

class ContactDetailController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contact: Contact?
    weak var delegate: ContactDetailControllerDelegate?
    
    
    convenience public init() {
        
        let bundle = Bundle(for: ASContactPicker.self)
        self.init(nibName: ContactDetailController.className, bundle: bundle)
    }
    
    fileprivate func categories() -> [String] {
        //return ["phones", "emails", "birthday"]
        return ["phones"]
    }

    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
        setupTableView()
    }
    
    fileprivate func setupController() {
        
        guard let contact = contact else { return }
        title = "\(contact.firstName)  \(contact.lastName)"
        navigationController?.navigationBar.barTintColor = ASContactPicker.barColor
        navigationController?.navigationBar.tintColor = .white
        automaticallyAdjustsScrollViewInsets = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                                NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)]
    }
    
    func createHeader(_ contact: Contact) -> UIView {
        
        let bundle = Bundle(for: ASContactPicker.self)
        let nib = UINib(nibName: ContactHeader.className, bundle: bundle)
            
        if let header = nib.instantiate(withOwner: self, options: nil)[0] as? ContactHeader {
            header.setNeedsLayout()
            header.layoutIfNeeded()
            header.frame = CGRect(x: 40, y: 20, width: tableView.frame.size.width - 40, height: 350)
            header.setupHeader(contact)
            return header
        }
        return UIView()
    }
    
    fileprivate func setupTableView() {
        
        guard let contact = contact else { return }
        let bundle = Bundle(for: ASContactPicker.self)
        tableView.register(UINib(nibName: ContactDetailCell.className, bundle: bundle),
                                                forCellReuseIdentifier: ContactDetailCell.className)
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = createHeader(contact)
        tableView.dataSource = self
        tableView.delegate = self as? UITableViewDelegate
    }
    
}

extension ContactDetailController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let contact = contact else { return 1 }
        
        switch section {
        case 0:
            return contact.phones.count
        case 1:
            return contact.emails.count
        case 2:
            return contact.birthday != "" ? 1 : 0
        default:
            break
        }

        return contact.phoneLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let contact = contact else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactDetailCell.className, for: indexPath) as! ContactDetailCell
        switch indexPath.section {
        case 0:
            cell.setupCell(contact.phones[indexPath.row], type: contact.phoneLabels[indexPath.row])
        case 1:
            cell.setupCell(contact.emails[indexPath.row], type: contact.emailLabels[indexPath.row])
        case 2:
            cell.setupCell(contact.birthdayDate.dateToStringFullMonth(), type: "birthday")
        default:
            break
        }

        return cell
    }
}

extension ContactDetailController: UITableViewDelegate {
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let phone = contact?.phones[indexPath.row] else { return }
        //let cell = tableView.dequeueReusableCell(withIdentifier: ContactDetailCell.className, for: indexPath) as! ContactDetailCell
        delegate?.getContact(phone)
        self.navigationController?.popViewController(animated: true)
    }
}
