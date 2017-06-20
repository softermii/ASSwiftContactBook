//
//  ContactsData.swift
//  ASContacts
//
//  Created by Anton Stremovskiy on 6/12/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import Foundation
import Contacts


class ContactsData: NSObject {
    
    let contactsStore = CNContactStore()
    
    let keysToFetch = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
        CNContactGivenNameKey,
        CNContactFamilyNameKey,
        CNContactEmailAddressesKey,
        CNContactPhoneNumbersKey,
        CNContactImageDataAvailableKey,
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
