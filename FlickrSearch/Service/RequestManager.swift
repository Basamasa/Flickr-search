//
//  NetworkManager.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 30.01.22.
//

import Foundation

/// Request helper that gives results from url request
class RequestManager {
    
    static let shared = RequestManager()
    
    static let errorMessage = "Something went wrong, Please try again later"
    static let noInternetConnection = "Please check your Internet connection and try again."
    
    /**
     Request data from internet
     
     - Parameters:
        - request: Api request
        - completion: Handler to retrieve result
     */
    func request(_ request: Request) async -> Result<Data> {
        
        guard (Reachability.currentReachabilityStatus != .notReachable) else {
            return .Failure(RequestManager.noInternetConnection)
        }
        
        return await withCheckedContinuation { continuation in
            URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                
                guard error == nil else {
                    return continuation.resume(returning: .Failure(error!.localizedDescription))
                }
                
                guard let data1 = data else {
                    return continuation.resume(returning: .Failure(error?.localizedDescription ?? RequestManager.errorMessage))
                }
                
                guard let stringResponse = String(data: data1, encoding: String.Encoding.utf8) else {
                    return continuation.resume(returning: .Failure(error?.localizedDescription ?? RequestManager.errorMessage))
                }
                
                print("Respone: \(stringResponse)")
                
                return continuation.resume(returning: .Success(data1))
                
            }.resume()
        }
    }
}
