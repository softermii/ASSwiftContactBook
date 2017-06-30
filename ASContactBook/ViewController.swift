//
//  ViewController.swift
//  ASContactBook
//
//  Created by Anton Stremovskiy on 6/29/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBAction func showPicker() {
        
        let contacts = ContactsViewController(delegate: self)
        //let contacts = ContactsViewController(delegate: self, subTitle: .phone)
        let nav = UINavigationController(rootViewController: contacts)
        self.present(nav, animated: true, completion: nil)
    }
    
    
   
}

extension ViewController: ASContactBookPickerDelegate {

    func didSelectContacts(_: ContactsViewController, selectedContacts: [Contact]) {
        print(selectedContacts.count)
        selectedContacts.forEach { contact in debugPrint("\(contact.firstName) \(contact.lastName)") }
    }
}
