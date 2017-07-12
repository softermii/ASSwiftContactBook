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
    
    
    func setupHeader(_ contact: Contact) {
        
        let bundle         = Bundle(for: ASContactPicker.self)
        profileImage.image = contact.thumb ?? UIImage(named: "person", in: bundle, compatibleWith: nil)
        profileName.text   = contact.firstName + " " + contact.lastName
        profileDescription.text = contact.jobTitle + "\n\n" + contact.organization
        
    }
 
}
