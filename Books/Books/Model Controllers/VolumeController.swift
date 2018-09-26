//
//  VolumeController.swift
//  Books
//
//  Created by Daniela Parra on 9/25/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

class VolumeController {
    
    // MARK: - CRUD Methods
    
    //Create book
    
    //Update book
    
    //Delete book
    
    // MARK: - API Search Query
    
    //Search books
    func searchBooks(searchTerm: String, completion: @escaping (Error?) -> Void) {
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let queryParameters = ["q": searchTerm]
        
        components?.queryItems = queryParameters.map({URLQueryItem(name: $0.key, value: $0.value)})
        
        guard let requestURL = components?.url else {
            completion(NSError())
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error searching for books with search term \(searchTerm): \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            do {
                let searchResults = try JSONDecoder().decode(VolumeSearchResults.self, from: data)
                self.volumes = searchResults.items
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
        
    }
    
    // MARK: - Properties
    
    var volumes: [VolumeRepresentation] = []
    
    private let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes")!
}
