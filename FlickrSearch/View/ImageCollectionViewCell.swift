//
//  ImageCollectionViewCell.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 28.01.22.
//

import UIKit

/// Cell view for image conllection
class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var ImageLabel: UILabel!
    
    var model: ImageViewModel? {
        didSet {
            if let model = model {
                ImageView.image = UIImage(named: "placeholder")
                ImageView.loadImageUsingCache(withUrl: model.imageURL)
            }
        }
    }
    
}
