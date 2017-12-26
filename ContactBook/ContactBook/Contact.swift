//
//  Contact.swift
//  ASContacts
//
//  Created by Anton Stremovskiy on 6/9/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import Foundation
import Contacts
import UIKit


open class Contact: NSObject {
    
    public var contactId: String     = ""
    public var firstName: String     = ""
    public var lastName: String      = ""
    public var jobTitle: String      = ""
    public var organization: String  = ""
    public var birthday: String      = ""
    public var image: UIImage?       = nil
    public var thumb: UIImage?       = nil
    public var phones: [String]      = []
    public var emails: [String]      = []
    public var phoneLabels: [String] = []
    public var emailLabels: [String] = []
    
    public var name = "" {
        didSet {
            if name.count > 0 {
                firstName = name
            }
        }
    }
    
    public var last = "" {
        didSet {
            if name.count > 0 {
                lastName = last
            }
        }
    }
    
    
    public var originPhones = [CNLabeledValue<CNPhoneNumber>]() {
        didSet {
            originPhones.forEach { phone in
                phones.append(phone.value.stringValue)
                guard let label = phone.label else { return }
                phoneLabels.append(CNLabeledValue<NSString>.localizedString(forLabel: label))
            }
        }
    }
    
    public var originEmails = [CNLabeledValue<NSString>]() {
        didSet {
            originEmails.forEach { email in
                emails.append((email.value as NSString) as String)
                guard let label = email.label else { return }
                emailLabels.append(CNLabeledValue<NSString>.localizedString(forLabel: label))
            }
        }
    }
    
    public var birthdayDate = Date() {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/YYYY"
            birthday = formatter.string(from: birthdayDate)
        }
    }
}
