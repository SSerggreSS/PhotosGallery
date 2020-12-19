//
//  DetailsVC.swift
//  PhotosGallery
//
//  Created by Сергей  Бей on 27.11.2020.
//

import UIKit

class DetailsVC: UIViewController {

    var imageScrollView: ImageScrollView!
    var image: UIImage?
    let label: UILabel = {
        let l = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = .red
        return l
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        imageScrollView = ImageScrollView(frame: view.bounds)

        view.addSubview(imageScrollView)
        setupImageScrollView()
        setImageForScrollView()
    }

    private func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
             imageScrollView.topAnchor.constraint(equalTo: view.topAnchor),
             imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
    }
    
    private func setImageForScrollView() {
        guard let image = image else { return }
        imageScrollView.set(image: image)
    }
    
}
