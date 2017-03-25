//
//  PlacesProvider.swift
//  Discountcard
//
//  Created by test on 03/11/16.
//  Copyright © 2016 Mooncascade Ou. All rights reserved.
//

import Foundation
import SwiftyJSON

class PlacesProvider {
    
    static func getPlaces(completion: @escaping (([Place]) -> Void)) {
        let requestURL = NSURL(string: "https://discountcard.aw.ee/organization/1/places")!
        let urlRequest = NSMutableURLRequest(url: requestURL as URL)
        urlRequest.httpMethod = "GET"
        let username = "android"
        let password = "bOTd6gkggjPESfhzBUVt"
        let encodedCredentials = String(format: "%@:%@",username, password)
        let loginData = encodedCredentials.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                if error != nil {
                    let pm = PlacesManager(data: nil)
                    completion(pm.placesArray)
                    return
                }
                guard let data = data else { return }
                let pm = PlacesManager(data: data)
                completion(pm.placesArray)
            }
        }
        session.resume()
    }
}
