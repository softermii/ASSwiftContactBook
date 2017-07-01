
# ASSwiftContactBook
Contact Book written in Swift 3.0

Supports iOS 9 and later

![Swift 3.0](https://img.shields.io/badge/Swift-3.0-green.svg?style=flat)

### Usage:
```
pod 'ASSwiftContactBook'
```


```swift
let contacts = ContactsViewController(delegate: self, subTitle: .phone)
let nav = UINavigationController(rootViewController: contacts)
self.present(nav, animated: true, completion: nil)
```
### Options:
- **.phone**
- **.email**
- **.birthday**
- **.organization**

### Screenshots:

![Screenshot](https://preview.ibb.co/nxkAq5/Simulator_Screen_Shot_Jul_1_2017_10_08_52.png)


### TODO:

- [ ] Create detailed contact view
- [ ] Implement single contact selection
- [ ] Add call/compose email actions


## Author:
@antons81 - Anton Stremovskiy
