//
//  BookshelfController.swift
//  Book List
//
//  Created by Moin Uddin on 9/25/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation
import CoreData

class BookshelfController {
    
    init() {
        fetchBookShelvesFromServer()
    }
    
    
    func createBookshelf(title: String, id: Int16, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let _ = Bookshelf(title: title, id: id)
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error creating an bookshelf \(error)")
        }
        //Can't create bookshelf in server
        //put(bookshelf: bookshelf)
    }
    
    func update(bookshelf: Bookshelf, bookshelfRepresentation: BookshelfRepresentation) {
        bookshelf.title = bookshelfRepresentation.title
        bookshelf.id = bookshelfRepresentation.id
    }
    
    func saveToPersistent() {
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error Saving to Core Data: \(error)")
        }
    }
    
    func fetchSingleBookshelfFromPersistentStore(id: Int16, context: NSManagedObjectContext) -> Bookshelf? {
        let fetchRequest: NSFetchRequest<Bookshelf> = Bookshelf.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        
        var bookshelf: Bookshelf? = nil
        
        do {
            bookshelf = try context.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching bookshelf with UUID \(id): \(error)")
        }
        
        return bookshelf
    }
    
    
    
    func fetchBookShelvesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseUrl.appendingPathComponent("mylibrary").appendingPathComponent("bookshelves")
        let request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: request) {(data, _, error) in
            if let error = error {
                NSLog("Error getting all Bookshelves: \(error)")
                completion(error)
            }
            
            guard let data = data else {
                NSLog("No data was returned")
                completion(NSError())
                return
            }
            
            do {
                let bookshelfRepresentations =  try JSONDecoder().decode(BookshelfRepresentations.self, from: data).items
                let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                
                
                backgroundContext.performAndWait {
                    for bookshelfRep in bookshelfRepresentations {
                        if let bookshelf = self.fetchSingleBookshelfFromPersistentStore(id: bookshelfRep.id, context: backgroundContext) {
                            if bookshelf != bookshelfRep {
                                print("goes to update bookshelf in core data")
                                self.update(bookshelf: bookshelf, bookshelfRepresentation: bookshelfRep)
                            }
                        } else {
                            print("goes to create bookshelf in core data")
                            _ = Bookshelf(bookshelfRepresentation: bookshelfRep, context: backgroundContext)
                        }
                    }
                }
                
            } catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(error)
            }
            
            }.resume()
    }
    
    typealias CompletionHandler = (Error?) -> Void
    var fetchedBookshelves: [Bookshelf] = []
    var baseUrl = URL(string: "https://www.googleapis.com/books/v1/")!
    
}
