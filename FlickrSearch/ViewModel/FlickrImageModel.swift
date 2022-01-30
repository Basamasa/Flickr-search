//
//  FlickrImageModel.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 28.01.22.
//

import UIKit

class FlickrImageViewModel {
    private(set) var photos = [Photo]()
    private var searchText = ""
    private var pageNo = 1
    private var totalPageNo = 1
    
    var showAlert: ((String) -> Void)?
    var dataUpdated: (() -> Void)?
    
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
                    self.showAlert?(message)
                    completion()
                case .Error(let error):
                    if self.pageNo > 1 {
                        self.showAlert?(error)
                    }
                    completion()
                }
            }
        }
    }
    
    func search(text: String, completion:@escaping () -> Void) {
        searchText = text
        photos.removeAll()
        fetchResults(completion: completion)
    }
    
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
