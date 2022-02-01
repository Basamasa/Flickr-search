//
//  FlickrImageModel.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 28.01.22.
//

import UIKit

/// View model for search and fetch images
class FlickrImageViewModel {
    private(set) var photos = [Photo]()
    private var searchText = ""
    private var pageNo = 1
    private var totalPageNo = 1
    
    var dataUpdated: (() -> Void)?
    
    /**
     Fetch results with giving search text and page number
     
     - Parameters:
        - completion: Handler to retrieve result
     */
    private func fetchResults(completion:@escaping () -> Void) {
        FlickrAPI().requestText(searchText, pageNo: pageNo) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let results):
                    if let result = results {
                        self.totalPageNo = result.pages
                        self.photos.append(contentsOf: result.photo)
                        self.dataUpdated?()
                    }
                    completion()
                case .Failure(let message):
                    print(message)
                    completion()
                case .Error(let error):
                    print(error)
                    completion()
                }
            }
        }
    }
    
    /**
     Search and fetch results with giving search text
     
     - Parameters:
        - searchText: Search term
        - completion: Handler to retrieve result
     */
    func search(text: String, completion:@escaping () -> Void) {
        searchText = text
        photos.removeAll()
        fetchResults(completion: completion)
    }
    
    /**
     Fetch next page result when scroll to bottom
     
     - Parameters:
        - completion: Handler to retrieve result
     */
    func fetchNextPage(completion:@escaping () -> Void) {
        if pageNo < totalPageNo {
            pageNo += 1
            fetchResults {
                completion()
            }
        } else {
            completion()
        }
    }
}
