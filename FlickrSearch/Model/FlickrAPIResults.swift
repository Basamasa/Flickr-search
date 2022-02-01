//
//  FlickrAPIResults.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 29.01.22.
//

import UIKit

/// Returned results from flickr api
struct FlickrAPIResults: Codable {
    let photos: Photos?
    let stat: String?
}
