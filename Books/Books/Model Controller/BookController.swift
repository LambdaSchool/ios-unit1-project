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
            completion(nil)
        }
    }
    
//    func syncPersistenceStoreWithGoogle{
//
//        let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
//        self.fetchAndCompareFromPersistentStore(bookRepresentations: bookRepresentations, shelfID: shelf, context: backgroundContext)
//
//    }
    
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
    
    func fetchAndCompareFromPersistentStore(bookRepresentations: [BookRepresentation], shelfID: Int, context: NSManagedObjectContext){
        context.performAndWait {
            
            
            for bookRepresentation in bookRepresentations{
                
                guard let id = bookRepresentation.id else {return}
                let books = fetchFromPersistentStore(id: id, context: context)
                
                //creates array of all the shelves that contain a book
                var shelvesContainingBook = [Int]()
                for book in books {
                    shelvesContainingBook.append(Int(book.shelfID))
                    //uses iteration to check if books that are on shelf "have read" are marked read"
                    if !book.haveRead && (shelfID == 4) {
                        book.haveRead = true
                    }
                }
                //if book does not exist in the shelf add book
                if !shelvesContainingBook.contains(shelfID){
                    Book(bookRepresentation: bookRepresentation, shelfID: shelfID, context: context)
                }
                
            }
        }
        
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("Error saving: \(error)")
                context.reset()
            }
        }
    }
    
    
    //MARK: - Properties
    var bookRepresentationsDirectory = [Int: [BookRepresentation]]()
    var searchResults = [BookRepresentation]()
}
