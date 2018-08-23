//
//  BookController.swift
//  Books
//
//  Created by Linh Bouniol on 8/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation
import CoreData

class BookController {

    // MARK: - CRUD
    
    func createBook(with searchResult: SearchResult, inBookshelf bookshelf: Bookshelf) {
        
        // When searching for the same book that we already have, we don't want to create a new one in core data. So lets ask core data if it already has the book, and update it if it does.
        
        let identifier = searchResult.identifier
        
        var bookFromPersistentStore = self.fetchSingleBookFromPersistentStore(withID: identifier, context: CoreDataStack.shared.mainContext)
        
        if let book = bookFromPersistentStore {
            self.update(book: book, with: searchResult)
        } else {
            bookFromPersistentStore = Book(searchResult: searchResult)
        }
        
        guard let book = bookFromPersistentStore else { return }
        book.addToBookshelves(bookshelf)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error creating book: \(error)")
        }
    }

    func move(book: Book, to bookshelf: Bookshelf, from oldBookshelf: Bookshelf? = nil) {
        if let oldBookshelf = oldBookshelf {
            book.removeFromBookshelves(oldBookshelf)
        }
        
        book.addToBookshelves(bookshelf)

        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error moving book: \(error)")
        }
    }

    func toggleHasRead(for book: Book) {
        book.hasRead = !book.hasRead

        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error updating book: \(error)")
        }
    }
    
    func update(book: Book, with review: String) {
        book.review = review
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error updating book review: \(error)")
        }
    }

    func delete(book: Book) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(book)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error deleting book: \(error)")
        }
    }
    
    func createBookshelf(with name: String) {
        let _ = Bookshelf(name: name)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error creating bookshelf: \(error)")
        }
    }

    func rename(bookshelf: Bookshelf, with newName: String) {
        bookshelf.name = newName

        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error renaming bookshelf: \(error)")
        }
    }

    func delete(bookshelf: Bookshelf) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(bookshelf)
        
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error deleting bookshelf: \(error)")
        }
    }
    
    // MARK: - Google Books API
    
    typealias CompletionHandler = (Error?) -> Void
    
    func fetchBookshelvesFromGoogleServer(completion: @escaping CompletionHandler = { _ in }) {
        
        let myBookshelvesURL = URL(string: "https://www.googleapis.com/books/v1/mylibrary/bookshelves")!
        
        var request = URLRequest(url: myBookshelvesURL)
        request.httpMethod = "GET"
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            if let error = error {
                NSLog("Error authorizing bookshelves: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let request = request else {
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, _, error) in
                if let error = error {
                    NSLog("Error loading bookshelves: \(error) ")
                    DispatchQueue.main.async {
                        completion(error)
                    }
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(NSError())
                    }
                    return
                }
                
                do {
                    let decodedBookshelves = try JSONDecoder().decode(BookshelvesRepresentation.self, from: data)
                    
                    let backgroundMOC = CoreDataStack.shared.container.newBackgroundContext()
                    
                    try self.updateBookshelves(with: decodedBookshelves.items, context: backgroundMOC)
                    
                    DispatchQueue.main.async {
                        completion(nil)
                    }

                } catch {
                    NSLog("Error decoding bookshelves: \(error)")
                    DispatchQueue.main.async {
                        completion(error)
                    }
                }
            }).resume()
        }
    }
    
    func fetchSingleBookshelfFromPersistentStore(withID id: Int, context: NSManagedObjectContext) -> Bookshelf? {
        
        let fetchRequest: NSFetchRequest<Bookshelf> = Bookshelf.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", id as NSNumber)
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching bookshelf with id \(id): \(error)")
            return nil
        }
    }
    
    func update(bookshelf: Bookshelf, with bookshelfRepresentation: BookshelfRepresentation) {
        bookshelf.name = bookshelfRepresentation.title
    }
    
    func updateBookshelves(with bookshelves: [BookshelfRepresentation], context: NSManagedObjectContext) throws {
        var error: Error?
        
        context.performAndWait {
            for bookshelfRepresentation in bookshelves {
                
                let id = bookshelfRepresentation.id
                
                let bookshelf = self.fetchSingleBookshelfFromPersistentStore(withID: id, context: context)
                
                if let bookshelf = bookshelf {
                    if bookshelf != bookshelfRepresentation {
                        self.update(bookshelf: bookshelf, with: bookshelfRepresentation)
                    }
                } else {
                    Bookshelf(bookshelfRepresentation: bookshelfRepresentation, context: context)
                }
            }
            
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        
        if let error = error {
            throw error
        }
    }
    
    func fetchSingleBookFromPersistentStore(withID identifier: String, context: NSManagedObjectContext) -> Book? {
        
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching book with id \(identifier): \(error)")
            return nil
        }
    }
    
    func update(book: Book, with searchResult: SearchResult) {
        book.title = searchResult.title
        book.authorsString = searchResult.authors?.joined(separator: ", ")
        book.imageURL = searchResult.image
        book.bookDescription = searchResult.descripton
        book.pages = searchResult.pages
        book.releasedDate = searchResult.releasedDate
    }
}
