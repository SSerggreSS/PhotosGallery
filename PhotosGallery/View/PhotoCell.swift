//
//  PhotoCell.swift
//  PhotosGallery
//
//  Created by Сергей  Бей on 27.11.2020.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PhotoCell"
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate(
            [
             imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
             imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
             imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
             imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ]
        )
    }
    
    func setImage(urlString: String?) {
        guard let urlStr = urlString else { return }
        guard let url = URL(string: urlStr) else { return }
        imageView.sd_setImage(with: url, completed: nil)
    }
    
}
