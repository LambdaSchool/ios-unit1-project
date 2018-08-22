//
//  BookSearchDetailViewController.swift
//  ios-google-books
//
//  Created by Conner on 8/22/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit

class BookSearchDetailViewController: UIViewController {
  
  @IBOutlet var bookTitleLabel: UILabel!
  @IBOutlet var bookAuthorLabel: UILabel!
  @IBOutlet var bookSynopsisLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let book = book {
      bookTitleLabel.text = book.volumeInfo.title
      
      if let author = book.volumeInfo.authors {
        bookAuthorLabel.text = author[0]
      }
      
      bookSynopsisLabel.text = book.volumeInfo.description
    }
  }
  
  @IBAction func saveToRead(_ sender: Any) {
    if let book = book {
      if let author = book.volumeInfo.authors {
        bookController?.createBook(title: book.volumeInfo.title, author: author[0], synopsis: book.volumeInfo.description ?? "")
      }
//      bookController?.createBook(title: book.volumeInfo.title, author: book.volumeInfo.authors[0], synopsis: book.volumeInfo.description ?? "")
      do {
        try bookController?.saveToPersistentStore()
      } catch {
        NSLog("Error saving book from API search to Core Data")
      }
      navigationController?.popViewController(animated: true)
    }
  }
  
  var book: BookRepresentation?
  var bookController: BookController?
}
