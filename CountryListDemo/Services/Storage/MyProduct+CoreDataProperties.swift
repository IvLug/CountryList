//
//  MyProduct+CoreDataProperties.swift
//  
//
//  Created by Ivan Lugantsov on 11.05.2022.
//
//

import Foundation
import CoreData


extension MyProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyProduct> {
        return NSFetchRequest<MyProduct>(entityName: "MyProduct")
    }

    @NSManaged public var id: Float
    @NSManaged public var name: String?

}
