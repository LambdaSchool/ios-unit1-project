//
//  BookController.swift
//  Books
//
//  Created by Andrew Liao on 8/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit
import CoreData


private let moc = CoreDataStack.shared.mainContext

private let baseURL = URL(string: "https://www.googleapis.com/books/v1")!

class BookController{
    // MARK: - Search Google API
    typealias CompletionHandler = (Error?) -> Void
    
    func fetchVolumeFromGoogle(searchTerm: String, completion:@escaping CompletionHandler = { _ in } ){
        
        //build URL for URLRequest
        let queryURL = baseURL.appendingPathComponent("volumes")
        var urlComponents = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "q", value: searchTerm),
                                     URLQueryItem(name: "maxResults", value: "30")]
        
        guard let url = urlComponents?.url else {
            NSLog("Error creating URL")
            return
        }
        
        //build URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //get data from Books API
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error sending request: \(error)")
            }
            guard let data = data else {
                NSLog("Data is nil")
                return}
            
            do{
                let decoded = try JSONDecoder().decode(Bookshelf.self, from: data)
                
                self.searchResults = decoded.items!
                completion(nil)
            } catch {
                NSLog("Error decoding: \(error)")
            }
            
            }.resume()
    }
    
    func fetchBooksFromGoogle( completion:@escaping CompletionHandler = {_ in}){

        //initialize dispatch group
        let group = DispatchGroup()
        for shelf in 0 ... 8 {
            //enter the tunnel!
            group.enter()
            
            let bookshelvesURL = baseURL
                .appendingPathComponent("mylibrary")
                .appendingPathComponent("bookshelves")
                .appendingPathComponent(String(shelf))
                .appendingPathComponent("volumes")
            
            let request = URLRequest(url: bookshelvesURL)
            
            GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
                if let error = error {
                    NSLog("Error adding authorization to fetch request: \(error)")
                    group.leave()
                    return
                }
                guard let request = request else {group.leave(); return}
                
                URLSession.shared.dataTask(with: request){ (data, _, error) in
                    if let error = error {
                        NSLog("Error sending request: \(error)")
                        group.leave()
                        return
                    }
                    guard let data = data else {
                        NSLog("Data is nil")
                        group.leave()
                        return}
                    do{
                        let decodedBookRepresentations = try JSONDecoder().decode(Bookshelf.self, from: data).items
                        guard let bookRepresentations = decodedBookRepresentations else { group.leave(); return}
                        
                        //add entries to bookRepresentationsDirectory
                        self.bookRepresentationsDirectory[shelf] = bookRepresentations
                    }catch {
                        NSLog("Error decoding fetch data: \(error)")
                    }
                    // group leaves
                    group.leave()
                    }.resume()
            }
        }
        //notifies mainQueue that everyone in the group has left.
        group.notify(queue: .main) {
            let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
            self.syncPersistenceStoreWithGoogle(directory: self.bookRepresentationsDirectory, context: backgroundContext)
            
            completion(nil)
        }
    }
    
    func syncPersistenceStoreWithGoogle(directory: [Int: [BookRepresentation]], context: NSManagedObjectContext){
        context.perform {
            self.fetchAndCompareFromPersistentStore(directory: directory, context: context)
            
        }
    }
    
    func fetchAndCompareFromPersistentStore(directory: [Int: [BookRepresentation]], context: NSManagedObjectContext){
        
        var books = [Book]()
        
        for (shelf, bookRepresentations) in directory{
            //checks persistence store to see if it has a book for each bookRepresentation on Books API
            for bookRepresentation in bookRepresentations {
                
                guard let id = bookRepresentation.id else {return}
                let fetchedBooks = fetchFromPersistentStore(id: id, context: context)
                for book in fetchedBooks{
                    books.append(book)
                }
                //creates array of all the shelves that contain a book
                var shelvesContainingBook = [Int]()
                for book in books {
                    shelvesContainingBook.append(Int(book.shelfID))
                    //uses iteration to check if books that are on shelf "have read" are marked read"
                    if !book.haveRead && (book.shelfID == 4) {
                        book.haveRead = true
                    }
                }
                //if book does not exist in the shelf add book
                if !shelvesContainingBook.contains(shelf){
                    Book(bookRepresentation: bookRepresentation, shelfID: shelf, context: context)
                }
            }
        }
        
        //checks to make sure that persistence doesn't have extra books that may result from changes
        //such as moving and deleting on the API side.
        print (books.count)
        for book in books{
            let shelfID = Int(book.shelfID)
            if let bookRepresentations = directory[shelfID] {
                
                let isShelved = doesShelfContainBook(book: book, bookRepresentations: bookRepresentations)
                
                if !isShelved{
                    deleteFromPersistentStore(book: book, context: context)
                }
            } else {
                deleteFromPersistentStore(book: book, context: context)
            }
        }
        
        //save changes
        saveToPersistentStore(context: context)
        
    }
    
    func doesShelfContainBook(book: Book, bookRepresentations: [BookRepresentation]) -> Bool {
        for bookRepresentation in bookRepresentations {
            if book.volumeID == bookRepresentation.id{
                return true
            }
        }
        return false
    }
    
    func fetchFromPersistentStore(id: String, context: NSManagedObjectContext) -> [Book]{
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        request.predicate = NSPredicate(format: "volumeID == %@", id)
        var books = [Book]()
        context.performAndWait {
            do{
                books = try context.fetch(request)
            } catch {
                NSLog("Error fetching from persistent store: \(error)")
            }
        }
        return books
    }
    //CRUD: - Functions
    func update(book:Book, review: String, haveRead: Bool){
        book.review = review
        book.haveRead = haveRead
        saveToPersistentStore()
    }
    
    
    
    
    
    //MARK: - Persistence Functions
    
    func deleteFromPersistentStore(book: Book, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        context.delete(book)
    }
    
    func saveToPersistentStore(context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        do{
            try context.save()
        } catch {
            NSLog("Error saving to persistent store: \(error)")
            context.reset()
        }
    }
    
    
    
    //MARK: - Properties
    var searchResults = [BookRepresentation]()
    private (set) var bookRepresentationsDirectory = [Int: [BookRepresentation]]()
}
