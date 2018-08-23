//
//  BookController.swift
//  books-list
//
//  Created by De MicheliStefano on 21.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

class BookController {
    
    // MARK: - Properties
    
    var searchedBooks: [BookRepresentation] = []
    let googleBooksBaseURL = URL(string: "https://www.googleapis.com/books/v1")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - API Methods
    func fetchFromGoogleBooks(with searchTerm: String, completion: @escaping (Error?) -> Void) {
        let url = googleBooksBaseURL.appendingPathComponent("volumes")
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
        let searchQueryItem = URLQueryItem(name: "q", value: searchTerm)
        urlComponents?.queryItems = [searchQueryItem]
        
        guard let requestURL = urlComponents?.url else {
            NSLog("Problem constructing search IRL for \(searchTerm)")
            completion(NSError())
            return
        }
        
        let request = URLRequest(url: requestURL)
        
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
                    let results = try JSONDecoder().decode(BookRepresentations.self, from: data)
                    if let items = results.items {
                        let bookRepresentations = items
                        self.searchedBooks = bookRepresentations
                        completion(nil)
                    }
                    //TODO: Add information to the user that no volumes were found
                    NSLog("No volumes found")
                    completion(NSError())
                } catch {
                    NSLog("Error decoding volumes: \(error)")
                    completion(error)
                    return
                }
            }.resume()
        }
    }
    
    func fetchImageDataFromGoogleBooks(withURL url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            completion(data, error)
        }.resume()
    }
    
    // MARK: - Persistence Methods
    
    func create(_ bookRepresentation: BookRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Book? {
        if let book = fetchSingleBookFromPersistenceStore(forIdentifier: bookRepresentation.id) {
            return book
        } else {
            let book = Book(bookRepresentation: bookRepresentation)
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving book to persistence store: \(error)")
            }
            return book
        }
    }
    
    func markAsRead(for book: Book, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            book.hasRead = true
            
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving markAsRead to persistence: \(error)")
            }
        }
    }
    
    private func fetchSingleBookFromPersistenceStore(forIdentifier identifier: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Book? {
        var book: Book?
        
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        context.performAndWait {
            do {
                book = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching book from persistence store: \(error)")
                book = nil
            }
        }
        
        return book
    }

    // MARK: - Private Methods
    
    
}
