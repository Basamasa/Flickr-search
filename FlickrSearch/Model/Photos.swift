//
//  FlickrPhotos.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 29.01.22.
//

import UIKit

/// Returned photos from flickr api
struct Photos: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let photo: [Photo]
    let total: Int
}
