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
            
            
            //            guard let stringData:String = String(data: data, encoding: String.Encoding.utf8) else {return}
            //            print(stringData)
            
            do{
                let decoded = try JSONDecoder().decode(Bookshelf.self, from: data)
                
                self.searchResults = decoded.items!
                completion(nil)
            } catch {
                NSLog("Error decoding: \(error)")
            }
            
            }.resume()
    }
    
    func fetchBooksFromGoogle(completion: @escaping CompletionHandler = {_ in}){
        
        for shelf in 0 ... 8 {
            let bookshelvesURL = baseURL
                .appendingPathComponent("mylibrary")
                .appendingPathComponent("bookshelves")
                .appendingPathComponent(String(shelf))
                .appendingPathComponent("volumes")
            
            let request = URLRequest(url: bookshelvesURL)

            
            GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
                if let error = error {
                    NSLog("Error adding authorization to fetch request: \(error)")
                    return
                }
                guard let request = request else {return}

                URLSession.shared.dataTask(with: request){ (data, _, error) in
                    if let error = error {
                        NSLog("Error sending request: \(error)")
                        return
                    }
                    
                    guard let data = data else {
                        NSLog("Data is nil")
                        return}
                    //                    guard let stringData:String = String(data: data, encoding: String.Encoding.utf8) else {return}
                    //                    print(shelf)
                    //                    print(stringData)
                    
                    //decode JSONData
                    do{
                        let decodedBookRepresentations = try JSONDecoder().decode(Bookshelf.self, from: data).items
                        guard let bookRepresentations = decodedBookRepresentations else {return}
                        let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                        self.fetchAndCompareFromPersistentStore(bookRepresentations: bookRepresentations, shelfID: shelf, context: backgroundContext)
                        
                        
                        
                        //check the volumes of bookshelf and compare with persistent store
                        /*
                         if bookrepresentation.id = book.id then do nothing
                         if not, create new book
                         
                         */
                    }catch {
                        NSLog("Error decoding fetch data: \(error)")
                    }
                    
                    }.resume()
                
            }
        }
        completion(nil)
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
    
    func fetchAndCompareFromPersistentStore(bookRepresentations: [BookRepresentation], shelfID: Int, context: NSManagedObjectContext){
        context.performAndWait {
            
           
            for bookRepresentation in bookRepresentations{

                let id = bookRepresentation.id
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
    var searchResults = [BookRepresentation]()
}
