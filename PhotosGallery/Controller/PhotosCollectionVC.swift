//
//  PhotosCollectionVC.swift
//  PhotosGallery
//
//  Created by Сергей  Бей on 27.11.2020.
//

import UIKit
import CoreData

class PhotosCollectionVC: UICollectionViewController {
    
    let networkService = NetworkService()
    let networkFetcher = NetworkDataFetcher()
    
    var unsplashPhotos = [Result]()
    
    var context: NSManagedObjectContext!
    var dataWasRequestedFromTheServer = false
    var photosFromDataBase: [Photo]?
    
    private var numberOfcolumns: Int {
        return searchController.searchBar.selectedScopeButtonIndex + 1
    }
    
    private let sectionEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    //MARK: Properties UI
    
    private lazy var timer: Timer? = nil
    
    private let labelPhotos: UIBarButtonItem = {
        let l = UILabel()
        l.text = "PHOTOS"
        return UIBarButtonItem(customView: l)
    }()
    
    private let searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.obscuresBackgroundDuringPresentation = false
        sc.hidesNavigationBarDuringPresentation = true
        sc.searchBar.scopeButtonTitles = ["one", "two"]
        return sc
    }()
    
    //MARK: Life cycle
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        self.collectionView?.register(PhotoCell.self,
                                      forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        
        setupNavigationItems()
        
        //get photos from data base
        if !dataWasRequestedFromTheServer {
            let requestPhoto: NSFetchRequest = Photo.fetchRequest()
            do {
                photosFromDataBase = try context.fetch(requestPhoto).reversed()
            } catch {
                fatalError()
            }
        }
    }
    
    //MARK: - Setup UI
    
    private func setupNavigationItems() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        //navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.leftBarButtonItem = labelPhotos
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataWasRequestedFromTheServer ? unsplashPhotos.count : photosFromDataBase?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier,
                                                      for: indexPath) as! PhotoCell
        let cellImage = configure(cell: cell, indexPath: indexPath)
        
        return cellImage
    }
    
    private func configure(cell: PhotoCell, indexPath: IndexPath) -> UICollectionViewCell {
        
        if dataWasRequestedFromTheServer {
            let unsplashPhoto = unsplashPhotos[indexPath.row]
            let photoURLString = unsplashPhoto.urls[PhotoResolution.regular.rawValue]
            cell.setImage(urlString: photoURLString)
        } else {
            guard let unsplashPhoto = photosFromDataBase?[indexPath.row] else { return UICollectionViewCell()}
            cell.imageView.image = UIImage(data: unsplashPhoto.imageData!)
        }
        return cell
    }
    
}

//MARK: - UISearchBarDelegate

extension PhotosCollectionVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text else { return }
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            self.networkFetcher.fetchImages(searchTerm: searchText) { (result) in
                guard let result = result else { return }
                self.dataWasRequestedFromTheServer = true
                self.unsplashPhotos = result.results
                self.collectionView.reloadData()
                
                DispatchQueue.global(qos: .background).async {
                    
                    let pageUnsplash: PageUnsplash = PageUnsplash(context: self.context)
                    let temporarySet = NSMutableSet()
                    for photo in self.unsplashPhotos {
                        let managetObjectPhoto = Photo(context: self.context)
                        managetObjectPhoto.height = Float(photo.height)
                        managetObjectPhoto.width = Float(photo.width)
                        managetObjectPhoto.likes = Int64(photo.likes)
                        managetObjectPhoto.createdAt = photo.createdAt
                        guard let urlStr = photo.urls["regular"] else { return }
                        guard let url = URL(string: urlStr) else { return }
                        let data = try? Data(contentsOf: url)
                        managetObjectPhoto.imageData = data
                        temporarySet.add(managetObjectPhoto)
                        //print(managetObjectPhoto.createdAt)
                    }
                    
                    pageUnsplash.addToPhotos(NSSet(set: temporarySet))
                    
                    try? self.context.save()
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("selectedScope = \(selectedScope)")
        collectionView.reloadData()
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension PhotosCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionEdgeInsets.left
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionEdgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var widthPerItem: CGFloat = 0.0
        var heightPerItem: CGFloat = 0.0
        
        if dataWasRequestedFromTheServer {
            let photo = unsplashPhotos[indexPath.row]
            let paddingWidth = sectionEdgeInsets.left * CGFloat((numberOfcolumns + 1))
            let availabelWidth = view.frame.width - paddingWidth
            widthPerItem = availabelWidth / CGFloat(numberOfcolumns)
            heightPerItem = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        } else {
            guard let photo = photosFromDataBase?[indexPath.row] else { return CGSize(width: 0.0, height: 0.0) }
            let paddingWidth = sectionEdgeInsets.left * CGFloat((numberOfcolumns + 1))
            let availabelWidth = view.frame.width - paddingWidth
            widthPerItem = availabelWidth / CGFloat(numberOfcolumns)
            heightPerItem = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        }
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
}


//MARK: - UICollectionViewDelegate

extension PhotosCollectionVC {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        print("indexPath = \(indexPath)")
        let detailsVC = DetailsVC()
        let photoCell = collectionView.cellForItem(at: indexPath) as? PhotoCell
        detailsVC.image = photoCell?.imageView.image
        navigationController?.show(detailsVC, sender: nil)
        
    }
    
}

//MARK: UIScrolViewDelegate

extension PhotosCollectionVC {
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(true)
    }
    
}
