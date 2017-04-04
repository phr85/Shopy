//
//  SYBasketTableViewCell.swift
//  Shopy
//
//  Created by Philippe H. Regenass on 01.04.17.
//  Copyright © 2017 treeinspired GmbH. All rights reserved.
//

import UIKit

class SYBasketTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let reuseIdentifier = "BasketCell"
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    //MARK: - Setup
    
    func setup() {
        self.selectionStyle = .none
    }
    
}
