//
//  SMArticle+CoreDataProperties.swift
//  Shopy
//
//  Created by Philippe H. Regenass on 01.04.17.
//  Copyright © 2017 treeinspired GmbH. All rights reserved.
//

import Foundation
import CoreData


extension SMArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SMArticle> {
        return NSFetchRequest<SMArticle>(entityName: "SMArticle")
    }

    @NSManaged public var itemCount: Double
    @NSManaged public var title: String?
    @NSManaged public var price: String?
    @NSManaged public var id: String

}
