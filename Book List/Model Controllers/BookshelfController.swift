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
        //Can't create bookshelf in server
        saveToPersistent()
    }
    
    func update(bookshelf: Bookshelf, bookshelfRepresentation: BookshelfRepresentation) {
        bookshelf.title = bookshelfRepresentation.title
        bookshelf.id = bookshelfRepresentation.id
    }
    
    func saveToPersistent(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error Saving to Core Data: \(error)")
        }
    }
    
    func fetchSingleBookshelfFromPersistentStore(id: String, context: NSManagedObjectContext) -> Bookshelf? {
        let fetchRequest: NSFetchRequest<Bookshelf> = Bookshelf.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        
        var bookshelf: Bookshelf? = nil
        
        do {
            bookshelf = try context.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching bookshelf with id \(id): \(error)")
        }
        
        return bookshelf
    }
    
    
    func fetchVolumeFromPersistentStore(id: String, context: NSManagedObjectContext) -> Volume? {
        let fetchRequest: NSFetchRequest<Volume> = Volume.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        
        var volume: Volume? = nil
        
        do {
            volume = try context.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching volume with id \(id): \(error)")
        }
        
        return volume
    }
    
    //Wasted time on this. Didn't need it. I can access the volumes from books in core data
    func fetchVolumesFromShelf(bookshelf: Bookshelf, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseUrl.appendingPathComponent("mylibrary").appendingPathComponent("bookshelves").appendingPathComponent(String(bookshelf.id)).appendingPathComponent("volumes")
        let request = URLRequest(url: requestURL)
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            if let error = error {
                NSLog("Error adding authorization to request: \(error)")
                completion(error)
                return
            }
            
            guard let request = request else { return }
            URLSession.shared.dataTask(with: request) {(data, _, error) in
                if let error = error {
                    NSLog("Error getting all volumes in bookshelf: \(error)")
                    completion(error)
                }
                
                guard let data = data else {
                    NSLog("No data was returned")
                    completion(NSError())
                    return
                }
                
                do {
                    let volumeRepresentations =  try JSONDecoder().decode(VolumeRepresentations.self, from: data).items
                    let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                    
                    self.saveToPersistent(context: backgroundContext)
                    completion(nil)
                    
                } catch {
                    NSLog("Error decoding JSON data: \(error)")
                    completion(error)
                }
                
                }.resume()
        }
    }
    
    
    func fetchBookShelvesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseUrl.appendingPathComponent("mylibrary").appendingPathComponent("bookshelves")
        let request = URLRequest(url: requestURL)
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            if let error = error {
                NSLog("Error adding authorization to request: \(error)")
                completion(error)
                return
            }
            
            guard let request = request else { return }
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
                        if let bookshelf = self.fetchSingleBookshelfFromPersistentStore(id: String(bookshelfRep.id), context: backgroundContext) {
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
                
                self.saveToPersistent(context: backgroundContext)
                completion(nil)
                
            } catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(error)
            }
            
            }.resume()
        }
    }
    
    typealias CompletionHandler = (Error?) -> Void
    var baseUrl = URL(string: "https://www.googleapis.com/books/v1/")!
    
}
