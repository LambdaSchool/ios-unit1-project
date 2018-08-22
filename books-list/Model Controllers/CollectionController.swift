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
    
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - API Methods
    
    func fetchFromGoogleBooks(completion: @escaping (Error?) -> Void) {
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
                    
                    // Filter all collections that are private since we can't add volumes to those
                    let publicCollectionRepresentations = collectionRepresentations.filter { $0.access == "PUBLIC" }
                    
                    let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                    
                    try self.syncPersistenceStore(with: publicCollectionRepresentations, context: backgroundContext)
                    
                    completion(nil)
                    
                } catch {
                    NSLog("Error decoding or syncing collections: \(error)")
                    completion(error)
                }
            }.resume()
        }
    }
    
    func post(_ book: Book, to collection: Collection, completion: @escaping CompletionHandler = { _ in }) {
        let url = googleBooksBaseURL
            .appendingPathComponent(URLComponents.mylibrary.rawValue)
            .appendingPathComponent(URLComponents.bookshelves.rawValue)
            .appendingPathComponent(collection.identifier!)
            .appendingPathComponent(URLComponents.addVolume.rawValue)
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "volumeId", value: book.identifier)]
        
        guard let requestURL = urlComponents?.url else {
            NSLog("Problem constructing URL component")
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethods.post.rawValue
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            if let error = error {
                NSLog("Error adding authorization to request: \(error)")
                completion(error)
                return
            }
            guard let request = request else { return }
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    NSLog("Error putting volumes to collection: \(error)")
                    completion(error)
                    return
                }
                
                completion(nil)
            }.resume()
        }
    }
    
    // MARK: - Persistence Methods
    
    func add(_ book: Book, to collection: Collection, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        post(book, to: collection)
        
        context.performAndWait {
            book.addToCollections(collection)
            
            do {
                try context.save()
            } catch {
                NSLog("Error saving book to collection: \(error)")
            }
        }
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
    
    private func syncPersistenceStore(with collectionRepresentations: [CollectionRepresentation], context: NSManagedObjectContext) throws {
        context.performAndWait {
            for collectionRep in collectionRepresentations {
                if let collection = fetchSingleCollectionFromPersistentStore(forIdentifier: String(collectionRep.identifier), context: context) {
                    if collectionRep != collection {
                        self.update(collection, with: collectionRep, context: context)
                    }
                } else {
                    let _ = Collection(collectionRepresentation: collectionRep, context: context)
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
