//
//  NetworkManager.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 30.01.22.
//

import Foundation

/// Request helper that gives results from url request
class RequestManager: NSObject {
    
    static let shared = RequestManager()
    
    static let errorMessage = "Something went wrong, Please try again later"
    static let noInternetConnection = "Please check your Internet connection and try again."
    
    /**
     Request data from internet
     
     - Parameters:
        - request: Api request
        - completion: Handler to retrieve result
     */
    func request(_ request: Request, completion: @escaping (Result<Data>) -> Void) {
        
        guard (Reachability.currentReachabilityStatus != .notReachable) else {
            return completion(.Failure(RequestManager.noInternetConnection))
        }
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard error == nil else {
                return completion(.Failure(error!.localizedDescription))
            }
            
            guard let data = data else {
                return completion(.Failure(error?.localizedDescription ?? RequestManager.errorMessage))
            }
            
            guard let stringResponse = String(data: data, encoding: String.Encoding.utf8) else {
                return completion(.Failure(error?.localizedDescription ?? RequestManager.errorMessage))
            }
            
            print("Respone: \(stringResponse)")
            
            return completion(.Success(data))
            
        }.resume()
    }
}
