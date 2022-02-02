//
//  ImageCollectionViewCell.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 28.01.22.
//

import UIKit

/// Cell view for image conllection
class ImageCollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    static let identifer = "ImageCollectionViewCell"
    
    var model: ImageViewModel? {
        didSet {
            if let model = model {
                imageView.image = UIImage(named: "placeholder")
                imageView.loadImageUsingCache(withUrl: model.imageURL)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.autoresizesSubviews = true
        
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
