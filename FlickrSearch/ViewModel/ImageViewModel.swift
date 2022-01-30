//
//  ImageViewModel.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 30.01.22.
//

import UIKit

struct ImageViewModel {

    let imageURL: String
    
    init(photo: Photo) {
        imageURL = photo.imageURL
    }
}
