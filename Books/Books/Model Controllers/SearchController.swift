//
//  SearchController.swift
//  Books
//
//  Created by Linh Bouniol on 8/20/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation

class SearchController {
    
    var searchResults = [SearchResult]()
    
    let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes")!
    
    func performSearch(with searchTerm: String, completion: @escaping ([SearchResult]?, Error?) -> Void) {
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        
        let searchQueryItem = URLQueryItem(name: "q", value: searchTerm)
        
        urlComponents.queryItems = [searchQueryItem]
        
        // Check if url can be created using the components and deal with error
        guard let requestURL = urlComponents.url else {
            NSLog("Problem constructing search URL for \(searchTerm)")
            completion(nil, NSError())
            return
        }
        
        // Get url request
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = data else {
                NSLog("Error fetching data. No data returned.")
                DispatchQueue.main.async {
                    completion(nil, NSError())
                }
                return
            }
            
            do {
                let results = try JSONDecoder().decode(SearchResults.self, from: data)
                DispatchQueue.main.async {
                    self.searchResults = results.items
                    completion(self.searchResults, nil)
                }
                
            } catch {
                NSLog("Unable to decode data into search result: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
}
