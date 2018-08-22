//
//  BookController.swift
//  Books
//
//  Created by Andrew Liao on 8/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit


private let moc = CoreDataStack.shared.mainContext

private let baseURL = URL(string: "https://www.googleapis.com/books/v1")!

class BookController{
    
    
    // MARK: - Search Google API
    typealias CompletionHandler = (Error?) -> Void
    
    func fetchVolumeFromGoogle(searchTerm: String, completion:@escaping CompletionHandler = { _ in } ){
        
        //build URL for URLRequest
        let queryURL = baseURL.appendingPathComponent("volumes")
        var urlComponents = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "q", value: searchTerm),
                                     URLQueryItem(name: "maxResults", value: "30")]
        
        guard let url = urlComponents?.url else {
            NSLog("Error creating URL")
            return
        }
        
        //build URLRequest
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //get data from Books API
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error sending request: \(error)")
            }
            guard let data = data else {
                NSLog("Data is nil")
                return}
            
            
            guard let stringData:String = String(data: data, encoding: String.Encoding.utf8) else {return}
            print(stringData)
            
            do{
                let decoded = try JSONDecoder().decode(Bookshelf.self, from: data)
                self.searchResults = decoded.items
                print(self.searchResults.first?.id)
                completion(nil)
            } catch {
                NSLog("Error decoding: \(error)")
            }
            
            }.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - Properties
    var searchResults = [BookRepresentation]()
}
