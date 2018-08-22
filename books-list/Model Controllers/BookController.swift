//
//  BookController.swift
//  books-list
//
//  Created by De MicheliStefano on 21.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

class BookController {
    
    // MARK: - Properties
    
    var searchedBooks: [BookRepresentation] = []
    let googleBooksBaseURL = URL(string: "https://www.googleapis.com/books/v1")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - API Methods
    func fetchFromGoogleBooks(with searchTerm: String, completion: @escaping (Error?) -> Void) {
        let url = googleBooksBaseURL.appendingPathComponent("volumes")
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
        let searchQueryItem = URLQueryItem(name: "q", value: searchTerm)
        urlComponents?.queryItems = [searchQueryItem]
        
        guard let requestURL = urlComponents?.url else {
            NSLog("Problem constructing search IRL for \(searchTerm)")
            completion(NSError())
            return
        }
        
        let request = URLRequest(url: requestURL)
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            if let error = error {
                NSLog("Error adding authorization to request: \(error)")
                completion(error)
                return
            }
            guard let request = request else { return }
            
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    NSLog("Error fetching volumes from Google Books API: \(error)")
                    completion(error)
                    return
                }
                
                guard let data = data else {
                    NSLog("Error fetching volumes")
                    completion(error)
                    return
                }
                
                do {
                    let results = try JSONDecoder().decode(BookRepresentations.self, from: data)
                    if let items = results.items {
                        let bookRepresentations = items
                        self.searchedBooks = bookRepresentations
                        completion(nil)
                    }
                    //TODO: Add information to the user that no volumes were found
                    NSLog("No volumes found")
                    completion(NSError())
                } catch {
                    NSLog("Error decoding volumes: \(error)")
                    completion(error)
                    return
                }
            }.resume()
        }
        
    }
    
    // MARK: - Persistence Methods
    
    

    // MARK: - Private Methods
    
    
}
