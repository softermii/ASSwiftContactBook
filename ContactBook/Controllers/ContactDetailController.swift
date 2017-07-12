//
//  ContactDetailController.swift
//  ASContactBook
//
//  Created by Anton Stremovskiy on 7/7/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import UIKit
import Foundation

class ContactDetailController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contact: Contact?
    
    
    convenience public init() {
        
        let bundle = Bundle(for: ASContactPicker.self)
        self.init(nibName: "ContactDetailController", bundle: bundle)
    }
    
    fileprivate func categories() -> [String] {
        return ["phones", "emails", "birthday"]
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
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                                NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)]
    }
    
    func createHeader(_ contact: Contact) -> UIView {
        
        if let view = Bundle.main.loadNibNamed("ContactHeader", owner: self, options: nil)?[0] as? ContactHeader {
            view.setupHeader(contact)
            return view
        }
        return UIView()
    }
    
    fileprivate func setupTableView() {
        
        guard let contact = contact else { return }
        let bundle = Bundle(for: ASContactPicker.self)
        tableView.register(UINib(nibName: String(describing: ContactDetailCell.self), bundle: bundle),
                                                forCellReuseIdentifier: "detailCell")
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = createHeader(contact)
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
            return 1
        default:
            break
        }

        return contact.phoneLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let contact = contact else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! ContactDetailCell
        switch indexPath.section {
        case 0:
            cell.setupCell(contact.phones[indexPath.row], type: contact.phoneLabels[indexPath.row])
        case 1:
            cell.setupCell(contact.emails[indexPath.row], type: contact.emailLabels[indexPath.row])
        case 2:
            cell.setupCell(contact.birthday, type: "")
        default:
            break
        }
        
        return cell
    }
}
