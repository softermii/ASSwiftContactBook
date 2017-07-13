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
    
    var contactDetail: ((_ contact: Contact) -> Void)? = nil
    var contactData: Contact?
    
    func setupDetailTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ContactCell.onImageTap))
        profileImage.addGestureRecognizer(tap)
    }
    
    
    func setupCell(contact: Contact, subtitleType: SubtitleType) {
        
        let bundle = Bundle(for: ASContactPicker.self)
        
        contactData = contact
        fullName.text = "\(String(describing: contact.firstName)) \(String(describing: contact.lastName))"
        profileImage.tintColor = ASContactPicker.barColor
        profileImage.image = contact.thumb ?? UIImage(named: "person", in: bundle, compatibleWith: nil)
        setupDetailTap()
        
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
    
    func onImageTap() {
        guard let contact = contactData else { return }
        contactDetail?(contact)
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        profileImage.image = UIImage(named: "person")
        fullName.text = nil
        subTitle.text = nil
        contactData = nil
    }
}
