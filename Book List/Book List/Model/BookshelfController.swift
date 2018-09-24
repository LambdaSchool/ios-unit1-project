//
//  BookshelfController.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation
import CoreData

class BookshelfController {
    private let baseURL = URL(string: "https://www.googleapis.com/books/v1")!
    
    init() {
        fetchBookshelves()
    }
    
    // MARK: - CRUD Methods
    func update(bookshelf: Bookshelf, with bookshelfRepresentation: BookshelfRepresentation) {
        bookshelf.title = bookshelfRepresentation.title
    }
    
    // MARK: - Persistence
    private func fetchSingleBookshelf(id: Int16, context: NSManagedObjectContext) -> Bookshelf? {
        let fetchRequest: NSFetchRequest<Bookshelf> = Bookshelf.fetchRequest()
        
        let predicate = NSPredicate(format: "id = %@", id)
        
        fetchRequest.predicate = predicate
        
        var bookshelf: Bookshelf? = nil
        
        context.performAndWait {
            do {
                bookshelf = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error retrieving single bookshelf.")
            }
        }
        
        return bookshelf
    }
    
    // MARK: Networking
    func fetchBookshelves(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("myLibrary").appendingPathComponent("bookshelves")
        let request = URLRequest(url: requestURL)
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            if let error = error {
                NSLog("Error adding authorization: \(error)")
                completion(error)
                return
            }
            
            guard let request = request else {
                NSLog("Don't have a request.")
                completion(NSError())
                return
            }
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) in
                if let error = error {
                    NSLog("Error GETting bookshelves: \(error)")
                    completion(error)
                    return
                }
                
                guard let data = data else {
                    NSLog("No data was returned.")
                    completion(NSError())
                    return
                }
                
                var bookshelfRepresentations: [BookshelfRepresentation] = []
                
                do {
                    let results = try JSONDecoder().decode(BookshelfRepresentationResults.self, from: data)
                    bookshelfRepresentations = results.items
                } catch {
                    NSLog("Error decoding data: \(error)")
                    completion(error)
                    return
                }
                
                let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                
                for bookshelfRepresentation in bookshelfRepresentations {
                    if let bookshelf = self.fetchSingleBookshelf(id: bookshelfRepresentation.id, context: backgroundContext) {
                        self.update(bookshelf: bookshelf, with: bookshelfRepresentation)
                    } else {
                        _ = Bookshelf(bookshelfRepresentation: bookshelfRepresentation, context: backgroundContext)
                    }
                }
                
            }).resume()
        }
    }
}
