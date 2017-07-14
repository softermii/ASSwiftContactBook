
# ASSwiftContactBook
ContactBook Picker written in Swift

Supports iOS 9 and later

![Swift 3.0](https://img.shields.io/badge/Swift-3.0-green.svg?style=flat)

### Install:
```
pod 'ASSwiftContactBook'
```

### Usage:
```swift
 // init contact picker with custom desire subtitle
 
 func showContactPicker {
    
	let contactsVC = ASContactPicker(subTitle: .phone, multipleSelection: true, shouldOpenContactDetail: true)
    	let nav = UINavigationController(rootViewController: contactsVC)
    	self.present(nav, animated: true, completion: nil)
 
 
   // init handler for selected contacts
   contacts.didSelectContacts = { contacts in
       print(contacts.count)
       contacts.forEach { contact in debugPrint("\(contact.firstName) \(contact.lastName)") }
   }

   // init handler for single contact, in case you choosed single selection
   contacts.didSelectSingleContact = { contact in
       debugPrint("\(contact.firstName) \(contact.phones[0].digits)")
   }
}

```

### Options:
- **.phone**
- **.email**
- **.birthday**
- **.organization**

### Video Demo:
![Screenshot](https://media.giphy.com/media/xUOrw1rYanIvZegIEw/giphy.gif)



### TODO:

- [ ] Create detailed contact view
- [x] Implement single contact selection
- [ ] Add call/compose email actions


## Author:
@antons81 - Anton Stremovskiy
