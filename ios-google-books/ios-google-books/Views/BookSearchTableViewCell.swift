//
//  BookSearchTableViewCell.swift
//  ios-google-books
//
//  Created by Conner on 8/22/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit

class BookSearchTableViewCell: UITableViewCell {
  func updateViews() {
    if let book = book {
      bookTitleLabel.text = book.volumeInfo.title
      if let author = book.volumeInfo.authors {
        bookAuthorLabel.text = author[0]
      }
      bookSynopsisLabel.text = book.volumeInfo.description
    }
  }
  
  @IBOutlet var bookTitleLabel: UILabel!
  @IBOutlet var bookAuthorLabel: UILabel!
  @IBOutlet var bookSynopsisLabel: UILabel!
  
  var book: BookRepresentation? {
    didSet {
      updateViews()
    }
  }
}
