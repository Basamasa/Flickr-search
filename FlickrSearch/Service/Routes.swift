//
//  APIRoutes.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 29.01.22.
//

import Foundation

/// Api routes for Flickr photos search api method
struct Routes {
    static let per_page = 50
    static var api_key = "136bb4dc9c1ade0aba1c974ac3e866db"
    static var baseURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=" + api_key + "&format=json&nojsoncallback=1&safe_search=1&per_page=\(per_page)&text=%@&page=%ld"
    
    static var imageURL = "https://farm66.static.flickr.com/65535/%@_%@.jpg"
    
    /**
     Return requested url base on serch text and page number
     
     - Parameters:
       - searchText: Search text
       - pageNo: Page number
     
     ```
      api_key = "key=%@,pageNo=%ld"
      var request = searchRequest(searchText: "abc", pageNo: 123)
      print(request)
      // key=abc,pageNo=123
     ```
     
     - returns: Request configuration
     */
    static func searchRequest(searchText: String, pageNo: Int) -> Request? {
        let urlString = String(format: Routes.baseURL, searchText, pageNo)
        let reqConfig = Request.init(requestMethod: .get, urlString: urlString)
        return reqConfig
    }
    
}

enum Result <T>{
    case Success(T)
    case Failure(String)
    case Error(String)
}

enum RequestMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    
    var value: String {
        return self.rawValue
    }
}
