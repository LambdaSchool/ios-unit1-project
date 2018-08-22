//
//  CollectionController.swift
//  books-list
//
//  Created by De MicheliStefano on 22.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

class CollectionController {
    
    
    // MARK: - Properties
    
    let googleBooksBaseURL = URL(string: "https://www.googleapis.com/books/v1")!
    
    enum HTTPMethods: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum URLComponents: String {
        case mylibrary
        case bookshelves
    }
    
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - API Methods
    
    func fetchAllFromGoogleBooks(completion: @escaping (Error?) -> Void) {
        let url = googleBooksBaseURL
                    .appendingPathComponent(URLComponents.mylibrary.rawValue)
                    .appendingPathComponent(URLComponents.bookshelves.rawValue)
        let request = URLRequest(url: url)
        
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
                    let collectionRepresentations = try JSONDecoder().decode(CollectionRepresentations.self, from: data).items
                    let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                    
                    try self.syncPersistenceStore(with: collectionRepresentations, context: backgroundContext)
                    
                    completion(nil)
                    
                } catch {
                    NSLog("Error decoding or syncing collections: \(error)")
                    completion(error)
                }
            }.resume()
        
        }
        
    }
    
    // MARK: - Persistence Methods
    
    func create(with title: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        // TODO: Add collection to Google bookshelf via put or post
        // Take the returned bookshelf object and pass in the identifier below:
        
        context.performAndWait {
            let _ = Collection(identifier: nil, title: title)
            do {
                try CoreDataStack.shared.save(context: context)
            } catch let createError {
                NSLog("Error saving collection to persistence: \(createError)")
                error = createError
            }
        }
        
        if let error = error { throw error }
    }
    
    func create(from collectionRepresentation: CollectionRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        // TODO: Add collection to Google bookshelf via put or post
        // Take the returned bookshelf object and pass in the identifier below:
        
        context.performAndWait {
            let _ = Collection(identifier: String(collectionRepresentation.identifier), title: collectionRepresentation.title)
            do {
                try CoreDataStack.shared.save(context: context)
            } catch let createError {
                NSLog("Error saving collection to persistence: \(createError)")
                error = createError
            }
        }
        
        if let error = error { throw error }
    }
    
    func update(_ collection: Collection, with collectionRepresentation: CollectionRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            collection.title = collectionRepresentation.title
        }
    }
    
    func syncPersistenceStore(with collectionRepresentations: [CollectionRepresentation], context: NSManagedObjectContext) throws {
        context.performAndWait {
            for collectionRep in collectionRepresentations {
                if let collection = fetchSingleCollectionFromPersistentStore(forIdentifier: String(collectionRep.identifier), context: context) {
                    if collectionRep != collection {
                        self.update(collection, with: collectionRep, context: context)
                    } else {
                        let _ = Collection(collectionRepresentation: collectionRep)
                    }
                }
            }
        }
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving collection to persistence: \(error)")
            throw error
        }
    }
    
    func fetchSingleCollectionFromPersistentStore(forIdentifier identifier: String, context: NSManagedObjectContext) -> Collection? {
        var collection: Collection?
        let fetchRequest: NSFetchRequest<Collection> = Collection.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        context.performAndWait {
            do {
                collection = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error saving data from persistence store: \(error)")
            }
        }
        
        if let collection = collection { return collection } else { return nil }
    }
    
    // MARK: - Private Methods
    
}
