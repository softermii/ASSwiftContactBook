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
    
    var contact: Contact?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.image = UIImage(named: "person")
        
    }
    
    private func setup() {
        profileImage.layer.cornerRadius = 20
        profileImage.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = UIImage(named: "person")
        fullName.text = nil
        phoneNumber.text = nil
        contact = nil
    }
}
