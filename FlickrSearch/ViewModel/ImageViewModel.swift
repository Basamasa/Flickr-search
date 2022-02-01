//
//  ImageViewModel.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 30.01.22.
//

import UIKit

/// View model for single image view
struct ImageViewModel {

    let imageURL: String
    
    init(photo: Photo) {
        imageURL = photo.imageURL
    }
}
