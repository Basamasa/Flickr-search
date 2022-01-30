//
//  FlickrAPIService.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 29.01.22.
//


import UIKit

class FlickrAPI: NSObject {
    
    func request(_ searchText: String, pageNo: Int, completion: @escaping (Result<Photos?>) -> Void) {
        
        guard let request = Routes.searchRequest(searchText: searchText, pageNo: pageNo) else {
            return
        }
        
        NetworkManager.shared.request(request) { (result) in
            switch result {
            case .Success(let responseData):
                if let model = self.processResponse(responseData) {
                    if let stat = model.stat, stat.uppercased().contains("OK") {
                        return completion(.Success(model.photos))
                    } else {
                        return completion(.Failure(NetworkManager.errorMessage))
                    }
                } else {
                    return completion(.Failure(NetworkManager.errorMessage))
                }
            case .Failure(let message):
                return completion(.Failure(message))
            case .Error(let error):
                return completion(.Failure(error))
            }
        }
    }
    
    func processResponse(_ data: Data) -> FlickrAPIResults? {
        do {
            print(data)
            let responseModel = try JSONDecoder().decode(FlickrAPIResults.self, from: data)
            return responseModel
            
        } catch {
            print("Data parsing error: \(error.localizedDescription)")
            return nil
        }
    }
}
