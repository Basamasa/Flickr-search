//
//  FlickrAPIService.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 29.01.22.
//


import UIKit

/// Api helper that request and parser json results
class FlickrAPI: NSObject {
    /**
     Flickr API request using the "flickr.photos.search" method, to get photos based on search text, page Number
     
     - Parameters:
        - searchText: Search term
        - pageNo: Page number
        - completion: Handler to retrieve result
     */
    func requestText(_ searchText: String, pageNo: Int) async -> Result<Photos?> {
        
        guard let request1 = Routes.searchRequest(searchText: searchText, pageNo: pageNo) else {
            return .Error("")
        }
        
        //        let publisher = URLSession.shared.dataTaskPublisher(for: request as URLRequest)
        //
        //        publisher.sink { completion in
        //            <#code#>
        //        } receiveValue: { value in
        //            <#code#>
        //        }
        
        let result = await RequestManager.shared.request(request1)
        switch result {
        case .Success(let responseData):
            if let model = self.parser(responseData) {
                if let stat = model.stat, stat.uppercased().contains("OK") {
                    let photos = model.photos
                    return .Success(photos)
                } else {
                    return .Failure(RequestManager.errorMessage)
                }
            } else {
                return .Failure(RequestManager.errorMessage)
            }
        case .Failure(let message):
            return .Failure(message)
        case .Error(let error):
            return .Failure(error)
        }
    }
    
    /**
     Parser(Decoder) for json data
     
     - Parameters:
        - data: Response data from api
     - Returns: FlickrAPIResults instance
     */
    func parser(_ data: Data) -> FlickrAPIResults? {
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
