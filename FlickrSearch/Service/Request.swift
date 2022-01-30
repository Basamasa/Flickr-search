//
//  Request.swift
//  FlickrSearch
//
//  Created by Anzer Arkin on 30.01.22.
//

import Foundation

class Request: NSMutableURLRequest {
    
    convenience init?(requestMethod: RequestMethod, urlString: String, bodyParams: [String: Any]? = nil) {
        
        guard let url =  URL.init(string: urlString) else {
            return nil
        }
        
        self.init(url: url)
        
        do {
            if let bodyParams = bodyParams {
                let data = try JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
                self.httpBody = data
            }
        } catch {
            print("Json serialization error")
        }
        
        self.httpMethod = requestMethod.value
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}
