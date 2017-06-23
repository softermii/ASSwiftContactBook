//
//  ContactsData.swift
//  ASContacts
//
//  Created by Anton Stremovskiy on 6/12/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import Foundation
import Contacts
import UIKit


class ContactsData: NSObject {
    
    let contactsStore = CNContactStore()
    
    let keysToFetch = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
        CNContactGivenNameKey,
        CNContactFamilyNameKey,
        CNContactEmailAddressesKey,
        CNContactPhoneNumbersKey,
        CNContactImageDataKey,
        CNContactThumbnailImageDataKey,
        CNContactThumbnailImageDataKey
        ] as [Any]
    
   lazy var contacts = Array<Contact>()
    
    
   func getAllContacts() -> [Contact] {
    
        self.getContactsAccess()
    
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        
        try? contactsStore.enumerateContacts(with: request, usingBlock: { (person, pointer) in
            
            
            let contact = Contact()
            contact.firstName = person.givenName
            contact.lastName = person.familyName
            contact.originPhones = person.phoneNumbers
            contact.originEmails = person.emailAddresses
            if let image = person.imageData, let thumb = person.thumbnailImageData {
                contact.image = UIImage(data: image)
                contact.thumb = UIImage(data: thumb)
            }
            self.contacts.append(contact)
        })
        return self.contacts
    }
    
    
    
   fileprivate func getContactsAccess() {
        
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        case .denied, .restricted:
            print("denied")
            return
        case .notDetermined:
            print("not determined")
            contactsStore.requestAccess(for: .contacts, completionHandler: { (success, error) in
                if success {
                }
            })
        default:
            print("already authorized")
        }
        
    }

    
    
}
