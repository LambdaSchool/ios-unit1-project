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
    // MARK: - Properties
    private let baseURL = URL(string: "https://www.googleapis.com/books/v1")!
    let bookController = BookController()
    
    // MARK: - CRUD Methods
    func update(bookshelf: Bookshelf, with bookshelfRepresentation: BookshelfRepresentation) {
        bookshelf.title = bookshelfRepresentation.title
    }
    
    func update(book: Book, with bookRepresentation: BookRepresentation, in bookshelf: Bookshelf?) {
        book.author = bookRepresentation.volumeInfo.authors?.joined(separator: ", ")
        book.pageCount = bookRepresentation.volumeInfo.pageCount ?? 0
        book.thumbnailURL = bookRepresentation.volumeInfo.imageLinks?.thumbnail
        book.imageURL = bookRepresentation.volumeInfo.imageLinks?.biggestImage
        if let bookshelf = bookshelf {
            book.addToBookshelves(bookshelf)
            bookshelf.addToBooks(book)
        }
        
    }
    
    func add(book: Book, to bookshelf: Bookshelf) {
        bookshelf.addToBooks(book)
        book.addToBookshelves(bookshelf)
        
        post(book: book, to: bookshelf)
    }
    
    // MARK: Networking
    /// Fetches all the bookshelves from the user's library and adds/updates them in CoreData
    func fetchBookshelves(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("mylibrary").appendingPathComponent("bookshelves")
        let request = URLRequest(url: requestURL)
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (newRequest, error) in
            if let error = error {
                NSLog("Error adding authorization to GET bookshelves request: \(error)")
                completion(error)
                return
            }
            
            guard let newRequest = newRequest else { return }
            
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
                    let results = try JSONDecoder().decode(BookshelvesRepresentationResults.self, from: data)
                    bookshelfRepresentations = results.items
                } catch {
                    NSLog("Error decoding data: \(error)")
                    completion(error)
                    return
                }
                
                let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                
                backgroundContext.performAndWait {
                    for bookshelfRepresentation in bookshelfRepresentations {
                        var bookshelf = self.fetchSingleBookshelf(title: bookshelfRepresentation.title, context: backgroundContext)
                        if let bookshelf = bookshelf {
                            self.update(bookshelf: bookshelf, with: bookshelfRepresentation)
                        } else {
                            bookshelf = Bookshelf(bookshelfRepresentation: bookshelfRepresentation, context: backgroundContext)
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
    
    /// Fetches all the books from a given bookshelf and adds them if they don't exist or updates them if they need to be updated.
    func fetchBooks(for bookshelf: Bookshelf, context: NSManagedObjectContext = CoreDataStack.shared.container.newBackgroundContext(), completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("mylibrary").appendingPathComponent("bookshelves").appendingPathComponent("\(bookshelf.id)").appendingPathComponent("volumes")
        let request = URLRequest(url: requestURL)
        guard let title = bookshelf.title else { return }
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            if let error = error {
                NSLog("Error adding authorization to GET books request: \(error)")
                completion(error)
                return
            }
            
            guard let request = request else { return }
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) in
                if let error = error {
                    NSLog("Error GETting books from bookshelf: \(error)")
                    completion(error)
                    return
                }
                
                guard let data = data else {
                    NSLog("No data was returned.")
                    completion(NSError())
                    return
                }
                
                var bookRepresentations: [BookRepresentation] = []
                
                do {
                    let results = try JSONDecoder().decode(BooksResults.self, from: data)
                    bookRepresentations = results.items ?? []
                } catch {
                    NSLog("Error decoding books data: \(error)")
                    completion(error)
                    return
                }
                
                let backgroundContext = context
                
                backgroundContext.performAndWait {
                    let backgroundBookshelf = self.fetchSingleBookshelf(title: title, context: backgroundContext)
                    
                    for bookRepresentation in bookRepresentations {
                        if let book = self.fetchSingleBook(id: bookRepresentation.id, context: backgroundContext) {
                            // Check to see if the book already exists
                            if book != bookRepresentation {
                                //Check to see if the book needs to be updated
                                self.update(book: book, with: bookRepresentation, in: backgroundBookshelf)
                            }
                            self.bookController.fetchImagesFor(book: book, context: backgroundContext)
                        } else {
                            // If not, create it on this bookshelf
                            let book = Book(bookRepresentation: bookRepresentation, bookshelf: backgroundBookshelf, context: backgroundContext)
                            self.bookController.fetchImagesFor(book: book, context: backgroundContext)
                        }
                    }
                }
                
                do {
                    try CoreDataStack.shared.save(context: backgroundContext)
                } catch {
                    NSLog("Error saving background context: \(error)")
                }
                
                self.cleanUpBookshelf(bookshelf)
                
                completion(nil)
            }).resume()
        }
    }
    
    /// Posts the given book to the given bookshelf
    private func post(book: Book, to bookshelf: Bookshelf, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("mylibrary").appendingPathComponent("bookshelves").appendingPathComponent("\(bookshelf.id)").appendingPathComponent("addVolume")
        
        let volumeQuery = URLQueryItem(name: "volumeId", value: book.id)
        
        var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [volumeQuery]
        guard let url = components?.url else {
            NSLog("Error getting url from components.")
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            if let error = error {
                NSLog("Error adding authorization to POST book request: \(error)")
                completion(error)
                return
            }
            
            guard let request = request else {
                completion(NSError())
                return
            }
            
            URLSession.shared.dataTask(with: request, completionHandler: { (_, _, error) in
                if let error = error {
                    NSLog("Error POSTing book to bookshelf: \(error)")
                    completion(error)
                    return
                }
                
                return
            }).resume()
        }
    }
    
    // MARK: - Utility Methods
    /// Fetches a single bookshelf based on the given title
    func fetchSingleBookshelf(title: String, context: NSManagedObjectContext) -> Bookshelf? {
        let fetchRequest: NSFetchRequest<Bookshelf> = Bookshelf.fetchRequest()
        
        let predicate = NSPredicate(format: "title = %@", title)
        
        fetchRequest.predicate = predicate
        
        var bookshelf: Bookshelf? = nil
        
        context.performAndWait {
            do {
                bookshelf = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error retrieving single bookshelf: \(error)")
            }
        }
        
        return bookshelf
    }
    
    /// Fetches a single book based on the given id
    private func fetchSingleBook(id: String, context: NSManagedObjectContext) -> Book? {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        
        let predicate = NSPredicate(format: "id = %@", id)
        
        fetchRequest.predicate = predicate
        
        var book: Book? = nil
        
        context.performAndWait {
            do {
                book = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error retrieving single book: \(error)")
            }
        }
        return book
    }
    
    /// Deletes duplicate
    private func cleanUpBookshelf(_ bookshelf: Bookshelf) {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        
        let predicate = NSPredicate(format: "bookshelves CONTAINS %@ ", bookshelf)
        
        fetchRequest.predicate = predicate
        
        let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
        
        backgroundContext.performAndWait {
            do {
                var books = try backgroundContext.fetch(fetchRequest)
                var booksToDelete: [Book] = []
                for _ in books {
                    let bookToCheck = books.removeFirst()
                    let duplicates = books.filter() { $0.id == bookToCheck.id }
                    // TODO: Write logic to update first book with missing data from any duplicates
                    booksToDelete.append(contentsOf: duplicates)
                }
                
                if booksToDelete.count > 0 {
                    for book in booksToDelete {
                        backgroundContext.delete(book)
                    }
                    
                    try backgroundContext.save()
                }
            } catch {
                NSLog("Error fetching books on bookshelf: \(error)")
            }
            
        }
    }
}
