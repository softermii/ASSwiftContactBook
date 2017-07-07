//
//  ContactCell.swift
//  ASContacts
//
//  Created by Anton Stremovskiy on 6/21/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import UIKit

open class ContactCell: UITableViewCell {
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var select: UIImageView!
    
    
    var contactData: Contact?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        let bundle = Bundle(for: ContactCell.self)
        profileImage.image = UIImage(named: "person", in: bundle, compatibleWith: nil)
        //select.tintColor = barColor
    }
    
    
    func setupCell(contact: Contact, subtitleType: SubtitleType) {
        
        let bundle = Bundle(for: ASContactPicker.self)
        contactData = contact
        
        fullName.text = "\(String(describing: contact.firstName)) \(String(describing: contact.lastName))"
        profileImage.image = contact.thumb ?? UIImage(named: "person", in: bundle, compatibleWith: nil)
        
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
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = UIImage(named: "person")
        fullName.text = nil
        subTitle.text = nil
        contactData = nil
    }
}
