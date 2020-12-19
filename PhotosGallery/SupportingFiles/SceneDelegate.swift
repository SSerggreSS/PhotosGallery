//
//  SceneDelegate.swift
//  PhotosGallery
//
//  Created by Сергей  Бей on 27.11.2020.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        let photosCollectionVC = PhotosCollectionVC(collectionViewLayout: UICollectionViewFlowLayout())
        photosCollectionVC.context = (UIApplication.shared.delegate as? AppDelegate)?.dataBaseHelper.persistentContainer.viewContext
        
        let nc = UINavigationController(rootViewController: photosCollectionVC)
        
        window?.rootViewController = nc
        window?.makeKeyAndVisible()
    }


    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.dataBaseHelper.saveContext()
    }


}

