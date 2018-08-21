//
//  BookTableViewCell.swift
//  ios-google-books
//
//  Created by Conner on 8/21/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
  
  func updateViews() {
    if let book = book {
      bookTitleLabel.text = book.title
      bookAuthorLabel.text = book.author
      bookSynopsisLabel.text = book.synopsis
    }
  }
  
  @IBOutlet var bookTitleLabel: UILabel!
  @IBOutlet var bookAuthorLabel: UILabel!
  @IBOutlet var bookSynopsisLabel: UILabel!
  
  var book: Book? {
    didSet {
      updateViews()
    }
  }
}
