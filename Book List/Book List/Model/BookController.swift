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
    func fetchThumbnailFor(book: Book, context: NSManagedObjectContext = CoreDataStack.shared.container.newBackgroundContext(), completion: @escaping CompletionHandler = { _ in }) {
        guard let urlString = book.thumbnailURL, let url = URL(string: urlString), book.thumbnailData == nil else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            context.performAndWait {
                book.thumbnailData = data
                book.imageData = data
                self.fetchImageFor(book: book, context: context, completion: { (_) in
                    do {
                        try context.save()
                    } catch {
                        NSLog("Error saving background context: \(error)")
                    }
                    completion(nil)
                })
            }
//
//            do {
//                try CoreDataStack.shared.save(context: context)
//            } catch {
//                NSLog("Error saving background context: \(error)")
//            }
        }.resume()
    }
    
    func fetchImageFor(book: Book, context: NSManagedObjectContext = CoreDataStack.shared.container.newBackgroundContext(), completion: @escaping CompletionHandler = { _ in }) {
        guard let urlString = book.imageURL, let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            context.performAndWait {
                book.imageData = data
            }
            
            completion(nil)
            }.resume()
    }
    
//    
//    func updateImagesForBooksIn(bookshelf: Bookshelf) {
//        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
//        let predicate = NSPredicate(format: "bookshelves CONTAINS %@", bookshelf)
//        fetchRequest.predicate = predicate
//        
//        let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
//        var books: [Book] = []
//        
//        backgroundContext.performAndWait {
//            do {
//                books = try backgroundContext.fetch(fetchRequest)
//            } catch {
//                NSLog("Error fetching books: \(error)")
//                return
//            }
//        }
//        
//        for book in books {
//            fetchThumbnailFor(book: book, context: backgroundContext)
//        }
//    }
}
