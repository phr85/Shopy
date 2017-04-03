//
//  SYHelpers.swift
//  Shopy
//
//  Created by Philippe H. Regenass on 03.04.17.
//  Copyright © 2017 treeinspired GmbH. All rights reserved.
//

import UIKit

class SYHelpers: NSObject {

    static func totalItemPrice(_ price:Float, numberOfItems count:Int, exchangeRate:Float) -> Float {
        return Float(price * Float(count) * exchangeRate)
    }
    
}
