//
//  BookController.swift
//  Book Library
//
//  Created by Jeremy Taylor on 8/21/18.
//  Copyright © 2018 Bytes-Random L.L.C. All rights reserved.
//

import Foundation

class BookController {
    
    private let baseURL = URL(string: "https://www.googleapis.com/books/v1/")!
    
    func searchForBook (with searchTerm: String, completion: @escaping (Error?) -> Void) {
        var components = URLComponents(url: baseURL.appendingPathComponent("volumes"), resolvingAgainstBaseURL: true)
        let queryParameters = ["q": searchTerm]
        components?.queryItems = queryParameters.map({URLQueryItem(name: $0.key, value: $0.value)})
        let url = components?.url!
        let request = URLRequest(url: url!)
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            
            if let error = error {
                NSLog("Error adding authorization to request: \(error)")
                return
            }
            guard let request = request else { return }
            
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    NSLog("Error getting volumes: \(error)")
                    return
                }
                guard let data = data else { return }
                
                do {
                    let bookRepresentations = try JSONDecoder().decode(VolumeRepresentations.self, from: data).items
                    self.searchedVolumes = bookRepresentations
                    print(self.searchedVolumes)
                    completion(nil)
                } catch {
                    NSLog("Error decoding JSON data: \(error)")
                    completion(error)
                }
            }.resume()
        }
        
    } // End of search func
    var searchedVolumes: [VolumeRepresentation] = []
    
} // end of class
