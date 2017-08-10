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
    
    var contactDetail: ((_ contact: Contact) -> Void)? = nil
    var contactData: Contact?
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        profileLabel.layer.cornerRadius = profileLabel.frame.size.height / 2
        profileLabel.layer.masksToBounds = true
        setupDetailTap()
    }
    
    func setupDetailTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ContactCell.onLabelTap))
        tap.numberOfTapsRequired = 1
        profileLabel.addGestureRecognizer(tap)
    }
    
    func setupCell(contact: Contact, subtitleType: SubtitleType) {

        contactData = contact
        fullName.text = "\(String(describing: contact.firstName)) \(String(describing: contact.lastName))"
        profileLabel.backgroundColor = ASContactPicker.barColor
    
        let firstName = contact.firstName.characters.first ?? Character.init("N/")
        let lastName = contact.lastName.characters.first ?? Character.init("A")
        profileLabel.text = "\(firstName)\(lastName)".uppercased()

        
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
        default:
            break
        }
    }
    
    func onLabelTap() {
        guard let contact = contactData else { return }
        if ASContactPicker.shouldOpenContactDetail {
            contactDetail?(contact)
        }
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        profileLabel.text = nil
        fullName.text = nil
        subTitle.text = nil
        contactData = nil
    }
}
