//
//  BookController.swift
//  Books
//
//  Created by Farhan on 9/24/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation
import CoreData

class BookController{
    
    // MARK: - Properties
    
    var searchedBooks: [BookRepresentation] = []
    
    typealias CompletionHandler = ((Error?) -> Void)
    let baseURL = URL(string: "https://www.googleapis.com/books/v1/")
    
    // MARK: - Local Methods
    
    func addBook(title: String, id: String, thumbnail: String?, avgRating: Double?, author: String?, publishedDate: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext ){
        
        let _ = Book(title: title, id: id, thumbnail: thumbnail, review: "", averageRating: avgRating, author: author, publishedDate: publishedDate)
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving book: \(error)")
        }
    }
    
    func deleteBook(book: Book){
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(book)
        try? moc.save()
       
    }
    
    // MARK: - API Functions
    
    func putBookOnBookShelf(book: Book, completion: @escaping (Error?) -> Void = {_ in}){
        // finish this OR pull stuff from fetched results contorller
    }
    
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
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error getting books: \(error)")
                return
            }
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            do{
                let searchResults = try JSONDecoder().decode(SearchResults.self, from: data).items
                self.searchedBooks = searchResults
                completion(nil)
            }catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(error)
            }
            
            }.resume()
        
    }
}
