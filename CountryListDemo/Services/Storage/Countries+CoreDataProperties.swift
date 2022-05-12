//
//  Countries+CoreDataProperties.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 11.05.2022.
//
//

import Foundation
import CoreData


extension Countries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Countries> {
        return NSFetchRequest<Countries>(entityName: "Countries")
    }

    @NSManaged public var country: Date?

}

extension Countries : Identifiable {

}
