//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Сергей  Бей on 05.12.2020.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var createdAt: String?
    @NSManaged public var height: Float
    @NSManaged public var imageData: Data?
    @NSManaged public var likes: Int64
    @NSManaged public var width: Float

}
