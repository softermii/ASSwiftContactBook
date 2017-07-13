//
//  ContactHeader.swift
//  ASContactBook
//
//  Created by Anton Stremovskiy on 7/12/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import UIKit

open class ContactHeader: UIView {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileDescription: UILabel!
    
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    
    var contact: Contact!
    
    // actions
    
    var didTapOnCall: ((_ contact: [String]) -> Void)? = nil
    
    
    func setupHeader(_ contact: Contact) {
        
        let bundle              = Bundle(for: ASContactPicker.self)
        self.contact            = contact
        profileImage.image      = contact.thumb ?? UIImage(named: "person", in: bundle, compatibleWith: nil)
        profileName.text        = contact.firstName + " " + contact.lastName
        profileDescription.text = contact.jobTitle + "\n\n" + contact.organization
        
        
    }
    
    @IBAction func callTap() {
       showAlertController(contact.phones)
    }
    
    
    func showAlertController(_ data: [String]) {
        
        let actionSheet = UIAlertController(title: "Make your choose", message: nil, preferredStyle: .actionSheet)
        
        for contact in data {
            let action = UIAlertAction(title: contact, style: .default, handler: { _ in
                if let url = URL(string: "tel://\(contact.digits)"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            })
            
            actionSheet.addAction(action)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancel)
       
        if let vc = UIApplication.shared.delegate?.window??.rootViewController?.presentedViewController {
            vc.present(actionSheet, animated: true, completion: nil)
        }
    }
    


    func onCallTap() {
        if let url = URL(string: "tel://\(contact.phones[0].digits)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
 
}
