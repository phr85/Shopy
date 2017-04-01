//
//  SYShopTableViewCell.swift
//  Shopy
//
//  Created by Philippe H. Regenass on 31.03.17.
//  Copyright © 2017 treeinspired GmbH. All rights reserved.
//

import UIKit

class SYShopTableViewCell: UITableViewCell {

    
    @IBOutlet var productTitel: UILabel!
    @IBOutlet var productImage: UIImageView!
    
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
