//
//  ProductData+CoreDataProperties.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 13.05.2022.
//
//

import Foundation
import CoreData

extension ProductData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductData> {
        return NSFetchRequest<ProductData>(entityName: "ProductData")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var model: [Data]?

}

extension ProductData : Identifiable {

}
