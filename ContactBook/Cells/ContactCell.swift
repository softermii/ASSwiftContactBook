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
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var select: UIImageView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var contactImage: UIImageView!
    
    var contactDetail: ((_ contact: Contact) -> Void)? = nil
    var contactData: Contact?
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contactImage.layer.cornerRadius = profileLabel.frame.size.height / 2
        self.contactImage.layer.masksToBounds = true
        self.profileLabel.layer.cornerRadius = profileLabel.frame.size.height / 2
        self.profileLabel.layer.masksToBounds = true
    }
    
    
    func setupCell(contact: Contact, subtitleType: SubtitleType) {

        self.contactData = contact
        self.fullName.text = "\(String(describing: contact.firstName)) \(String(describing: contact.lastName))"
        self.profileLabel.backgroundColor = ASContactPicker.barColor
    
        let firstName = contact.firstName.first ?? Character.init("N")
        let lastName = contact.lastName.first ?? Character.init("A")
        self.profileLabel.text = "\(firstName)\(lastName)".uppercased()
        
        self.updateUI(contact)

        switch subtitleType {
        case .phone:
            self.subTitle.text = contact.phones.count > 0 ? contact.phones[0] : ""
        case .email:
            self.subTitle.text = contact.emails.count > 0 ? contact.emails[0] : ""
        case .job:
            self.subTitle.text = "Job title: \(contact.jobTitle)"
        case .organization:
            self.subTitle.text = "Organization: \(contact.organization)"
        case .birthday:
            self.subTitle.text = "Birthday: \(contact.birthday)"
        default:
            break
        }
    }
    
    func updateUI(_ contact: Contact) {
        if contact.thumb != nil {
            stackView.insertArrangedSubview(contactImage, at: 0)
            contactImage.image = contact.thumb
            contactImage.isHidden = false
            profileLabel.isHidden = true
        } else {
            contactImage.isHidden = true
            profileLabel.isHidden = false
        }
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        self.profileLabel.text = nil
        self.fullName.text = nil
        self.subTitle.text = nil
        self.contactData = nil
    }
}
