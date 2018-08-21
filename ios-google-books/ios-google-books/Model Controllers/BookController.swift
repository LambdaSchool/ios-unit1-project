//
//  BookController.swift
//  ios-google-books
//
//  Created by Conner on 8/21/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation

class BookController {
  // createBook only temp for base setup
  func createBook(title: String, author: String, synopsis: String, hasRead: Bool = false) {
    let book = Book(title: title, author: author, synopsis: synopsis, hasRead: hasRead)
  }
}
