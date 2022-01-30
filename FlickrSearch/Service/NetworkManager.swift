//
//  NetworkManager.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 30.01.22.
//

import Foundation

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    static let errorMessage = "Something went wrong, Please try again later"
    static let noInternetConnection = "Please check your Internet connection and try again."
    
    func request(_ request: Request, completion: @escaping (Result<Data>) -> Void) {
        
        guard (Reachability.currentReachabilityStatus != .notReachable) else {
            return completion(.Failure(NetworkManager.noInternetConnection))
        }
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard error == nil else {
                return completion(.Failure(error!.localizedDescription))
            }
            
            guard let data = data else {
                return completion(.Failure(error?.localizedDescription ?? NetworkManager.errorMessage))
            }
            
            guard let stringResponse = String(data: data, encoding: String.Encoding.utf8) else {
                return completion(.Failure(error?.localizedDescription ?? NetworkManager.errorMessage))
            }
            
            print("Respone: \(stringResponse)")
            
            return completion(.Success(data))
            
        }.resume()
    }
}
