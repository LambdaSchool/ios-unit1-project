//
//  BookController.swift
//  ios-google-books
//
//  Created by Conner on 8/21/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation
import CoreData

class BookController {
  // createBook only temp for base setup
  func createBook(title: String, author: String, synopsis: String, hasRead: Bool = false) {
    let _ = Book(title: title, author: author, synopsis: synopsis, hasRead: hasRead)
  }
  
  func loadFromPersistentStore() -> [Book] {
    let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
    let moc = CoreDataManager.shared.mainContext
    
    do {
      return try moc.fetch(fetchRequest)
    } catch {
      NSLog("Error fetching books: \(error)")
      return []
    }
  }
  
  func saveToPersistentStore() {
    do {
      let moc = CoreDataManager.shared.mainContext
      try moc.save()
    } catch {
      NSLog("Error saving managed object context: \(error)")
    }
  }
  
  var books: [Book] {
    return loadFromPersistentStore()
  }
}
