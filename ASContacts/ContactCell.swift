//
//  ContactCell.swift
//  ASContacts
//
//  Created by Anton Stremovskiy on 6/21/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = UIImage(named: "person")
        fullName.text = nil
        phoneNumber.text = nil
    }
}
