//
//  ContactDetailController.swift
//  ASContactBook
//
//  Created by Anton Stremovskiy on 7/7/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import UIKit
import Foundation

class ContactDetailController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contact: Contact?
    
    
    convenience public init() {
        let bundle = Bundle(for: ASContactPicker.self)
        self.init(nibName: "ContactDetailController", bundle: bundle)
    }

    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    fileprivate func setupController() {
        guard let contact = contact else { return }
        title = "\(contact.firstName)  \(contact.lastName)"
        navigationController?.navigationBar.barTintColor = .coolBlue
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
}

extension ContactDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
}
