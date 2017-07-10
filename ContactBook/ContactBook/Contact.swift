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

public extension UIImage {
    public func getImageFromData(data: Data?) -> UIImage? {
        guard let data = data else { return UIImage(named: "person") }
        return UIImage(data: data)
    }
}

open class Contact: NSObject {
    
    public var contactId: String     = ""
    public var firstName: String     = ""
    public var lastName: String      = ""
    public var jobTitle: String      = ""
    public var organization: String  = ""
    public var birthday: String      = ""
    public var image                 = UIImage(named: "person")
    public var thumb                 = UIImage(named: "person")
    public var phones: [String]      = []
    public var emails: [String]      = []
    public var phoneLabels: [String] = []
    public var emailLabels: [String] = []
    
    
    public var originPhones = [CNLabeledValue<CNPhoneNumber>]() {
        didSet {
            originPhones.forEach { phone in
                phones.append(phone.value.stringValue)
                phoneLabels.append(CNLabeledValue<NSString>.localizedString(forLabel: phone.label!))
            }
        }
    }
    
    public var originEmails = [CNLabeledValue<NSString>]() {
        didSet {
            originEmails.forEach { email in
                emails.append((email.value as NSString) as String)
                emailLabels.append(CNLabeledValue<NSString>.localizedString(forLabel: email.label!))
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
