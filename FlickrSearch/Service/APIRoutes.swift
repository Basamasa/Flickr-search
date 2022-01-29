//
//  APIRoutes.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 29.01.22.
//

import Foundation

struct Routes {
    
    static var api_key = "136bb4dc9c1ade0aba1c974ac3e866db"
    
    static var baseURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=" + api_key + "&format=json&nojsoncallback=1&safe_search=1&text=apple"
    
    static var imageURL = "https://farm66.static.flickr.com/65535/%@_%@.jpg"
    
}
