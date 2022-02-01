//
//  FlickrAPIResults.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 29.01.22.
//

import UIKit

/// Flickr api returned results
struct FlickrAPIResults: Codable {
    let photos: Photos?
    let stat: String?
}
