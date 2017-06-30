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

extension UIImage {
    public func getImageFromData(data: Data?) -> UIImage? {
        guard let data = data else { return UIImage(named: "person") }
        return UIImage(data: data)
    }
}

class Contact: NSObject {
    
    var contactId: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var jobTitle: String = ""
    var organization: String = ""
    var birthday: String = ""
    var image = UIImage(named: "person")
    var thumb = UIImage(named: "person")
    var phones: [String] = []
    var emails: [String] = []

    
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
    
    var birthdayDate = Date() {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/YYYY"
            birthday = formatter.string(from: birthdayDate)
        }
    }
    

    
    
    
}
