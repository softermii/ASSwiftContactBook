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
        
        let contacts = ASContactPicker(subTitle: .phone)
        let nav = UINavigationController(rootViewController: contacts)
        self.present(nav, animated: true, completion: nil)
        
        contacts.didSelectContacts = { contacts in
            debugPrint(contacts.count)
            contacts.forEach { contact in debugPrint("\(contact.firstName) \(contact.lastName)") }
        }
    } 
}

