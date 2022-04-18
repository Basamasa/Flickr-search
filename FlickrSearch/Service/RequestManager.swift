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
        do {
            let (data, _) = try await URLSession.shared.data(for: request as URLRequest)
            
            guard String(data: data, encoding: String.Encoding.utf8) != nil else {
                return .Failure(RequestManager.errorMessage)
            }
            return .Success(data)
        } catch {
            return .Failure(error.localizedDescription)
        }
    }
}
