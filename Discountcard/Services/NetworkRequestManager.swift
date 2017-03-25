//
//  NetworkRequestManager.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation


enum URLRequestMethod: String {
    case get = "GET"
    case post = "POST"
}

class NetworkRequestManager {
    typealias ServerResponse = (data: Data?, response: URLResponse?, error: Error?)
    typealias NetworkResponse = (ServerResponse) -> Void
    
    static func getPlaces(completion: @escaping (([Place]) -> Void)) {
        let url = "https://my.awesome.rest.api"
        performRequest(url, requestMethod: .get) { (ServerResponse) in
            if ServerResponse.error != nil {
                let pm = PlacesManager(data: nil)
                completion(pm.placesArray)
                return
            }
            guard let data = ServerResponse.data else { return }
            let pm = PlacesManager(data: data)
            completion(pm.placesArray)
        }
    }
    
    static func postRecommendation(name: String, completion: @escaping NetworkResponse) {
        let postUrl = "https://my.awesome.rest.api/wish?organization_id=1&wish=" + name
        performRequest(postUrl, requestMethod: .post)
        { (ServerResponse) in
            completion((ServerResponse.data,
                        ServerResponse.response,
                        ServerResponse.error))
        }
    }
    
    private static func performRequest(_ url: String,
                             requestMethod: URLRequestMethod,
                             completion: @escaping NetworkResponse) {
        let requestURL = NSURL(string: url)!
        let urlRequest = NSMutableURLRequest(url: requestURL as URL)
        urlRequest.httpMethod = requestMethod.rawValue
        let username = "myusername"
        let password = "bOTd6gkggjadfasdPESfhzBUVt"
        let encodedCredentials = String(format: "%@:%@",username, password)
        let loginData = encodedCredentials.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared.dataTask(with: urlRequest as URLRequest) {
            (ServerResponse) in
            DispatchQueue.main.async {
                completion((data: ServerResponse.0,
                            response: ServerResponse.1,
                            error: ServerResponse.2))
            }
        }
        session.resume()
    }
}
