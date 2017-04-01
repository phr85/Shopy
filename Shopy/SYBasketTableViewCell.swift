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
    
    // MARK: -
    
    @IBOutlet var productTitel: UILabel!
    @IBOutlet var productImage: UIImageView!
    
    // MARK: - Initialization
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        setup()
    }
    
    //MARK: - Setup
    
    func setup() {
        
        self.selectionStyle = .none
        setupProductTitel()
    }
    
    func setupProductTitel() {
        self.productTitel.text = "test"
    }
    
}
