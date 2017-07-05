
# ASSwiftContactBook
Contact Book written in Swift 3.0

Supports iOS 9 and later

![Swift 3.0](https://img.shields.io/badge/Swift-3.0-green.svg?style=flat)

### Usage:
```
pod 'ASSwiftContactBook'
```


```swift
 // init contact picker with custom desire subtitle
 
 func showContactPicker {
   let contacts = ASContactPicker(subTitle: .phone)
   let nav = UINavigationController(rootViewController: contacts)
   self.present(nav, animated: true, completion: nil)
 
 // init handler for selected contacts
 contacts.didSelectContacts = { contacts in
      print(contacts.count)
      contacts.forEach { contact in debugPrint("\(contact.firstName) \(contact.lastName)") }
 }

// init handler for single contact
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

### Screenshots:
<img src="https://preview.ibb.co/nxkAq5/Simulator_Screen_Shot_Jul_1_2017_10_08_52.png" width="320" height="568">



### TODO:

- [ ] Create detailed contact view
- [x] Implement single contact selection
- [ ] Add call/compose email actions


## Author:
@antons81 - Anton Stremovskiy
