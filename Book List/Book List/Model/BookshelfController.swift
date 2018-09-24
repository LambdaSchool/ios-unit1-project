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
    private func fetchSingleBookshelf(title: String, context: NSManagedObjectContext) -> Bookshelf? {
        let fetchRequest: NSFetchRequest<Bookshelf> = Bookshelf.fetchRequest()
        
        let predicate = NSPredicate(format: "title = %@", title)
        
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
        let requestURL = baseURL.appendingPathComponent("mylibrary").appendingPathComponent("bookshelves")
        let request = URLRequest(url: requestURL)
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (newRequest, error) in
            if let error = error {
                NSLog("Error adding authorization: \(error)")
                completion(error)
                return
            }
            
            guard let newRequest = newRequest else {
                NSLog("Don't have a request.")
                completion(NSError())
                return
            }
            
            URLSession.shared.dataTask(with: newRequest, completionHandler: { (data, _, error) in
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
                
                backgroundContext.performAndWait {
                    for bookshelfRepresentation in bookshelfRepresentations {
                        if let bookshelf = self.fetchSingleBookshelf(title: bookshelfRepresentation.title, context: backgroundContext) {
                            self.update(bookshelf: bookshelf, with: bookshelfRepresentation)
                        } else {
                            _ = Bookshelf(bookshelfRepresentation: bookshelfRepresentation, context: backgroundContext)
                        }
                    }
                }
                do {
                    try CoreDataStack.shared.save(context: backgroundContext)
                } catch {
                    NSLog("Error saving background context: \(error)")
                    completion(error)
                    return
                }
                
            }).resume()
        }
    }
}
