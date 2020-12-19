//
//  PageUnsplash+CoreDataProperties.swift
//  
//
//  Created by Сергей  Бей on 05.12.2020.
//
//

import Foundation
import CoreData


extension PageUnsplash {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PageUnsplash> {
        return NSFetchRequest<PageUnsplash>(entityName: "PageUnsplash")
    }

    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for photos
extension PageUnsplash {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
