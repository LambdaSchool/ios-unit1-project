//
//  BookController.swift
//  Books
//
//  Created by Farhan on 9/24/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation

class BookController{
    
    typealias CompletionHandler = ((Error?) -> Void)
    let baseURL = URL(string: "https://www.googleapis.com/books/v1/")
    
    func searchForBook(with searchTerm: String, completion: @escaping CompletionHandler = {_ in}){
        
        let searchURL = baseURL?.appendingPathComponent("volumes")
        
        var components = URLComponents(url: searchURL!, resolvingAgainstBaseURL: true)
        let searchTermQueryItem = URLQueryItem(name: "q", value: searchTerm)
        components?.queryItems = [searchTermQueryItem]
        
        guard let requestURL = components?.url else {
            NSLog("error in generating URL")
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        print(request)
        
//        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
//
//            if let error = error {
//                NSLog("Error adding authorization to request: \(error)")
//                return
//            }
//            guard let request = request else { return }
        
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    NSLog("Error getting bookshelves: \(error)")
                    return
                }
                guard let data = data else { return }
                
                if let json = String(data: data, encoding: .utf8) {
                    print(json)
                }
                }.resume()
            
            
//        }
        
    }
}
