//
//  DataBaseHelper.swift
//  PhotosGallery
//
//  Created by Сергей  Бей on 02.12.2020.
//

import Foundation
import UIKit
import CoreData

class DataBaseHelper {

    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "PhotosGallery")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
