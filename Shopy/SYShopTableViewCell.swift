//
//  SYShopTableViewCell.swift
//  Shopy
//
//  Created by Philippe H. Regenass on 31.03.17.
//  Copyright © 2017 treeinspired GmbH. All rights reserved.
//

import UIKit
import GMStepper

class SYShopTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let reuseIdentifier = "ShopCell"
    
    // MARK: -
    
    @IBOutlet weak var productTitel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stepperButton: GMStepper!
    
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
