//
//  FlickrImage.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 29.01.22.
//

import UIKit

/// Returned photo von flickr api
struct Photo: Codable {
    
    let farm : Int
    let id : String
    
    let isfamily : Int
    let isfriend : Int
    let ispublic : Int
    
    let owner: String
    let secret : String
    let server : String
    let title: String
    
    var imageURL: String {
        let urlString = String(format: Routes.imageURL, id, secret)
        return urlString
    }
}
