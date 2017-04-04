//
//  SMArticle+CoreDataProperties.swift
//  Shopy
//
//  Created by Philippe H. Regenass on 01.04.17.
//  Copyright © 2017 treeinspired GmbH. All rights reserved.
//

import Foundation
import CoreData


extension SMBasketArticle {

    @NSManaged public var itemCount: Int16
    @NSManaged public var title: String?
    @NSManaged public var price: Float
    @NSManaged public var unit: String?
    @NSManaged public var id: String

}
