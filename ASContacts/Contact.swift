//
//  Contact.swift
//  ASContacts
//
//  Created by Anton Stremovskiy on 6/9/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import Foundation
import Contacts

class Contact: NSObject {
    
    var originPhones = [CNLabeledValue<CNPhoneNumber>]() {
        didSet {
            originPhones.forEach { phone in
                phones.append(phone.value.stringValue)
            }
        }
    }
    
    var originEmails = [CNLabeledValue<NSString>]() {
        didSet {
            originEmails.forEach { email in
                emails.append((email.value as NSString) as String)
            }
        }
    }
    
    var firstName: String = ""
    var lastName: String = ""
    var imageData: Data!
    var phones: [String] = []
    var emails: [String] = []
    
    
    
}
