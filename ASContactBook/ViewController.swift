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
        
        let contactsVC = ASContactPicker(subTitle: .phone, multipleSelection: false, shouldOpenContactDetail: true)
        let nav = UINavigationController(rootViewController: contactsVC)
        self.present(nav, animated: true, completion: nil)
        
        contactsVC.didSelectContacts = { contacts in
            debugPrint(contacts.count)
            contacts.forEach { contact in debugPrint("\(contact.firstName) \(contact.lastName)") }
        }
        
        contactsVC.didSelectSingleContact = { contact in
            debugPrint("\(contact.firstName) \(contact.phones[0].digits)")
        }
    } 
}

