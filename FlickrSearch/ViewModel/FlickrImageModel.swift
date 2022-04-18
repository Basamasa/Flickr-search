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
    private func fetchResults() async {
        let result = await FlickrAPI().requestText(searchText, pageNo: pageNo)
        DispatchQueue.main.async {
            switch result {
            case .Success(let results):
                if let result = results {
                    self.totalPageNo = result.pages
                    self.photos.append(contentsOf: result.photo)
                    self.dataUpdated?()
                }
            case .Failure(let message):
                print(message)
            case .Error(let error):
                print(error)
            }
        }
    }
    
    /**
     Search and fetch results with giving search text
     
     - Parameters:
        - searchText: Search term
        - completion: Handler to retrieve result
     */
    func search(text: String) async {
        searchText = text
        photos.removeAll()
        await fetchResults()
    }
    
    /**
     Fetch next page result when scroll to bottom
     
     - Parameters:
        - completion: Handler to retrieve result
     */
    func fetchNextPage() async {
        if pageNo < totalPageNo {
            pageNo += 1
            await fetchResults()
        } else {
            return
        }
    }
}
