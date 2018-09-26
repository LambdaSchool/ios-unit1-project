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
                        try context.save()
                    } catch {
                        NSLog("Error saving background context: \(error)")
                    }
                    completion(nil)
                })
            }
        }.resume()
    }
    
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
                        try context.save()
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
    
}
