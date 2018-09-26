//
//  BookshelfController.swift
//  Books
//
//  Created by Daniela Parra on 9/25/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

class BookshelfController {
    
    init() {
        
        fetchAllBookshelves { (_) in
            
        }
    }

    
    // MARK: - Networking (Books API)
    
    //Add volume to a bookshelf.
    
    //Update volume in a bookshelf.
    
    //Delete volume from a bookshelf.
    
    //Move volume to another bookshelf.
    
    
    //Get all bookshelves from user's profile.
    func fetchAllBookshelves(completion: @escaping (Error?) -> Void) {
        
        let requestURL = bookshelvesBaseURL
        let request = URLRequest(url: requestURL)
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            if let error = error {
                NSLog("Error adding authorization to request: \(error)")
                return
            }
            guard let request = request else { return }
            
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    NSLog("Error fetching data for bookshelves: \(error)")
                    completion(error)
                    return
                }
                
                guard let data = data else {
                    NSLog("No data returned from data task")
                    completion(NSError())
                    return
                }
                
                //prints out json
                if let json = String(data: data, encoding: .utf8) {
                    print(json)
                }
                
                do {
                    let searchResults = try JSONDecoder().decode(BookshelfResults.self, from: data)
                    self.bookshelves = searchResults.items
                } catch {
                    NSLog("Error decoding data: \(error)")
                    completion(error)
                    return
                }
                completion(nil)
            }.resume()
        }
        
    }
    
    // MARK: - Core Data Persistence
    
    //Fetch all bookshelves.
    
    //Put book in bookshelf.
    
    //Delete book from bookshelf.
    
    var bookshelves: [BookshelfRepresentation] = []
    
    private let userId = "111772930908716729442"
    private let bookshelvesBaseURL = URL(string: "https://www.googleapis.com/books/v1/mylibrary/bookshelves")!
}
