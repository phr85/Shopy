//
//  SMProducts+CoreDataProperties.swift
//  Shopy
//
//  Created by Philippe H. Regenass on 01.04.17.
//  Copyright © 2017 treeinspired GmbH. All rights reserved.
//

import Foundation
import CoreData


extension SMProducts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SMProducts> {
        return NSFetchRequest<SMProducts>(entityName: "SMProducts")
    }

    @NSManaged public var title: String?
    @NSManaged public var price: String?
    @NSManaged public var unit: String?
    @NSManaged public var id: String

}
