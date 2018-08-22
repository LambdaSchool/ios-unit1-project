//
//  BookController.swift
//  Books
//
//  Created by Andrew Liao on 8/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit


private let moc = CoreDataStack.shared.mainContext

private let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes")!

class BookController{
    
    
    // MARK: - Searching Google API
    typealias CompletionHandler = (Error?) -> Void
    
    func fetchVolumeFromGoogle(searchTerm: String, completion: CompletionHandler = { _ in } ){

        //build URL for URLRequest
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let searchQuery = URLQueryItem(name: "q", value: searchTerm)
        urlComponents?.queryItems = [searchQuery]
        
        guard let url = urlComponents?.url else {
            NSLog("Error creating URL")
            return
        }
        
        //build URLRequest
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        //add authorization request to URL
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            if let error = error {
                NSLog("Error adding authorization to URLRequest: \(error)")
                return
            }
            
            //get data from Books API
            URLSession.shared.dataTask(with: request!) { (data, _, error) in
                if let error = error {
                    NSLog("Error sending request: \(error)")
                }
                guard let data = data,
                    let stringData:String = String(data: data, encoding: String.Encoding.utf8) else {return}
                print(stringData)
                
                }.resume()
            
        }
        
     

        
        
        
        
        
        
        
    }
    
    
    //MARK: - Properties
}
