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
    
    var contacts = [Contact]() {
        didSet {
            tableView.reloadData()
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName:"ContactCell", bundle: nil), forCellReuseIdentifier: "contact")
        tableView.tableFooterView = UIView()
        //tableView.dragDelegate = self
        //tableView.dropDelegate = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dragInteractionEnabled = true
        
        self.contacts = ContactsData().getAllContacts()
        print("Found \(self.contacts.count) Contacts")
        
    }  
    
}

extension ContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath) as! ContactCell
        let contact = contacts[indexPath.row]
        
        cell.profileImage.image = UIImage(named: "person")
        cell.fullName.text = "\(contact.firstName) \(contact.lastName)"
        cell.phoneNumber.text = contact.phones.first
        return cell
    }
}

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}


/*extension ViewController : UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let person = contacts[indexPath.row]
        let personData = person.firstName.data(using: .utf8)
        let itemProvider = NSItemProvider(item: personData! as Data as NSSecureCoding, typeIdentifier: "contact")
        return [UIDragItem(itemProvider: itemProvider)]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath = 0
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
    }
    
}*/




