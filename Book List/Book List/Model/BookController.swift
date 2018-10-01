//
//  BookController.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation
import CoreData

class BookController {
    
    private let baseURL = URL(string: "https://www.googleapis.com/books/v1")!
    
    // MARK: - CRUD Methods
    func remove(book: Book, from bookshelf: Bookshelf) {
        
        book.removeFromBookshelves(bookshelf)
        bookshelf.removeFromBooks(book)
        
        removeFromServer(book: book, from: bookshelf)
        
        if book.bookshelves == nil || book.bookshelves!.count == 0 {
            CoreDataStack.shared.mainContext.delete(book)
        }
        
        do{
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        } catch {
            NSLog("Error saving main context: \(error)")
        }
        
    }
    
    // MARK: - Networking
    /// Fetches all the images for a given book.
    func fetchImagesFor(book: Book, context: NSManagedObjectContext = CoreDataStack.shared.container.newBackgroundContext(), completion: @escaping CompletionHandler = { _ in }) {
        guard let urlString = book.thumbnailURL, let url = URL(string: urlString), book.thumbnailData == nil else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            context.performAndWait {
                book.thumbnailData = data
                book.imageData = data
                self.fetchImageFor(book: book, context: context, completion: { (_) in
                    do {
                        try CoreDataStack.shared.save(context: context)
                    } catch {
                        NSLog("Error saving background context: \(error)")
                    }
                    completion(nil)
                })
            }
        }.resume()
    }
    
    /// Fetches the large image for a given book.
    func fetchImageFor(book: Book, context: NSManagedObjectContext = CoreDataStack.shared.container.newBackgroundContext(), completion: @escaping CompletionHandler = { _ in }) {
        guard let urlString = book.imageURL, let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
                
            }
            
            context.performAndWait {
                book.imageData = data
            }
            
            completion(nil)
            }.resume()
    }
    
    func fetchImagesFor(bookRepresentation: BookRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.container.newBackgroundContext(), completion: @escaping CompletionHandler = { _ in }) {
        guard let urlString = bookRepresentation.volumeInfo.imageLinks?.thumbnail, let url = URL(string: urlString), bookRepresentation.thumbnailData == nil else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            context.performAndWait {
                bookRepresentation.thumbnailData = data
                bookRepresentation.imageData = data
                self.fetchImageFor(bookRepresentation: bookRepresentation, context: context, completion: { (_) in
                    do {
                        try CoreDataStack.shared.save(context: context)
                    } catch {
                        NSLog("Error saving background context: \(error)")
                    }
                    completion(nil)
                })
            }
            }.resume()
    }
    
    func fetchImageFor(bookRepresentation: BookRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.container.newBackgroundContext(), completion: @escaping CompletionHandler = { _ in }) {
        guard let urlString = bookRepresentation.volumeInfo.imageLinks?.biggestImage, let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
                
            }
            
            context.performAndWait {
                bookRepresentation.imageData = data
            }
            
            completion(nil)
            }.resume()
    }
    
    private func removeFromServer(book: Book, from bookshelf: Bookshelf, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("mylibrary").appendingPathComponent("bookshelves").appendingPathComponent("\(bookshelf.id)").appendingPathComponent("removeVolume")
        
        let idQueryItem = URLQueryItem(name: "volumeId", value: book.id)
        
        var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [idQueryItem]
        guard let url = components?.url else {
            NSLog("Couldn't make a url from components.")
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            if let error = error {
                NSLog("Error adding authorization to delete POST request: \(error)")
                completion(error)
                return
            }
            
            guard let request = request else {
                completion(NSError())
                return
            }
            
            URLSession.shared.dataTask(with: request, completionHandler: { (_, _, error) in
                if let error = error {
                    NSLog("Error POSTing remove volume request: \(error)")
                    completion(error)
                    return
                }
                
                completion(nil)
                return
            }).resume()
        }
        
        
    }
    
}
