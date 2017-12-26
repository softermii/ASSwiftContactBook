//
//  ContactDetailCell.swift
//  ASContactBook
//
//  Created by Anton Stremovskiy on 7/12/17.
//  Copyright © 2017 áSoft. All rights reserved.
//

import UIKit



class ContactDetailCell: UITableViewCell {
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataType: UILabel!

    func setupCell(_ data: String, type: String) {
        dataLabel.text = data
        dataType.text = type
    }
}
