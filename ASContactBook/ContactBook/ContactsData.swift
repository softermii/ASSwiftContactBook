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
        CNContactFormatter.descriptorForRequiredKeys(for: .phoneticFullName),
        CNContactIdentifierKey,
        CNContactGivenNameKey,
        CNContactFamilyNameKey,
        CNContactEmailAddressesKey,
        CNContactPhoneNumbersKey,
        CNContactImageDataKey,
        CNContactBirthdayKey,
        CNContactJobTitleKey,
        CNContactOrganizationNameKey,
        CNContactThumbnailImageDataKey,
        CNContactThumbnailImageDataKey
        ] as [Any]
    
    lazy var contacts = Array<Contact>()
         let error: Error? = nil
    
    
   func getAllContacts() -> [Contact] {
    
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        request.sortOrder = .givenName
    
        try? contactsStore.enumerateContacts(with: request, usingBlock: { (person, pointer) in

            let contact = Contact()
            contact.firstName = person.givenName
            contact.lastName = person.familyName
            contact.originPhones = person.phoneNumbers
            contact.originEmails = person.emailAddresses
            contact.contactId = person.identifier
            contact.jobTitle = person.jobTitle
            
            if let date = person.birthday?.date {
                contact.birthdayDate = date
            }
            
            contact.organization = person.organizationName
      
            
            if let image = person.imageData, let thumb = person.thumbnailImageData {
                contact.image = UIImage(data: image)
                contact.thumb = UIImage(data: thumb)
            }
            self.contacts.append(contact)
        })
        return self.contacts
    }
    
    
    
    func getContactsAccess(success: (_ result: Bool) -> Void, failure: @escaping (_ result: Error) -> Void) {
        
        let status = CNContactStore.authorizationStatus(for: .contacts)

        switch status {
        case .denied, .restricted:
            print("denied")
            failure((error)!)
            return
        case .notDetermined:
            print("not determined")
            contactsStore.requestAccess(for: .contacts, completionHandler: { (success, error) in
                if (error != nil) { return }
            })
            success(true)
        default:
            print("already authorized")
            success(true)
            return
        }
    }

    
    
}
