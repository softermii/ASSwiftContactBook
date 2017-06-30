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
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var contactData: Contact?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.image = UIImage(named: "person")
        
    }
    
    
    func setupCell(contact: Contact, subtitleType: SubtitleType) {
        
        contactData = contact
        fullName.text = "\(String(describing: contact.firstName)) \(String(describing: contact.lastName))"
        profileImage.image = contact.thumb
        
        switch subtitleType {
        case .phone:
            subTitle.text = contact.phones.count > 0 ? contact.phones[0] : ""
        case .email:
            subTitle.text = contact.emails.count > 0 ? contact.emails[0] : ""
        case .job:
            subTitle.text = "Job title: \(contact.jobTitle)"
        case .organization:
            subTitle.text = "Organization: \(contact.organization)"
        case .birthday:
            subTitle.text = "Birthday: \(contact.birthday)"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = UIImage(named: "person")
        fullName.text = nil
        subTitle.text = nil
        contactData = nil
    }
}
