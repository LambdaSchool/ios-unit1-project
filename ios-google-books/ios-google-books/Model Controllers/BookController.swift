//
//  BookController.swift
//  ios-google-books
//
//  Created by Conner on 8/21/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://www.googleapis.com/books/v1/")!
class BookController {
  // createBook only temp for base setup
  func createBook(title: String, author: String, synopsis: String, hasRead: Bool = false, id: String, thumbnail: NSData, review: String = "") {
    let _ = Book(title: title, author: author, synopsis: synopsis, hasRead: hasRead, id: id, thumbnail: thumbnail, review: review)
  }
  
  func toggleRead(book: Book) throws {
    let moc = CoreDataManager.shared.mainContext
    
    var error: Error?
    
    moc.performAndWait {
      if book.hasRead {
        book.hasRead = !book.hasRead
        book.review = ""
      } else {
        book.hasRead = !book.hasRead
      }
      
      do {
        try moc.save()
      } catch let saveError {
        error = saveError
      }
    }
    
    if let error = error {
      throw error
    }
  }
  
  func deleteBook(book: Book) throws {
    let moc = CoreDataManager.shared.mainContext
    
    var error: Error?
    
    moc.performAndWait {
      moc.delete(book)
    
      do {
        try moc.save()
      } catch let saveError {
        error = saveError
      }
    }
    
    if let error = error {
      throw error
    }
  }
  
  func updateBook(book: Book, review: String) throws {
    let moc = CoreDataManager.shared.mainContext
    
    var error: Error?
    
    moc.performAndWait {
      book.review = review
      book.hasRead = true
      
      do {
        try moc.save()
      } catch let saveError {
        error = saveError
      }
    }
    
    if let error = error {
      throw error
    }
  }
  
  func saveToPersistentStore() throws {
    let moc = CoreDataManager.shared.mainContext
    
    var error: Error?
    
    moc.performAndWait {
      do {
        try moc.save()
      } catch let saveError {
        error = saveError
      }
    }
    
    if let error = error {
      throw error
    }
  }
  
  func searchBooksViaAPI(searchTerm: String, completion: @escaping ([BookRepresentation], Error?) -> Void) {
    let url = baseURL.appendingPathComponent("volumes")
    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
    urlComponents.queryItems = [URLQueryItem(name: "q", value: searchTerm)]
    
    var request = URLRequest(url: urlComponents.url!)
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: request) { (data, _, error) in
      if let error = error {
        NSLog("Error GET books: \(error)")
        return
      }
      
      if let data = data {
        do {
          let decoder = JSONDecoder()
          let books = try decoder.decode(BookRepresentationItems.self, from: data)
          completion(books.items, nil)
        } catch let error {
          NSLog("Error decoding data from GET: \(error)")
        }
      }
    }.resume()
  }
}
