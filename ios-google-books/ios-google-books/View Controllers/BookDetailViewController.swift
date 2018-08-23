//
//  BookDetailViewController.swift
//  ios-google-books
//
//  Created by Conner on 8/23/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let book = book {
      bookTitleLabel.text = book.title
      bookAuthorLabel.text = book.author
      bookSynopsisLabel.text = book.synopsis
      
      guard let imageData = book.thumbnail else { return }
      
      imageView.image = UIImage(data: imageData)

    }
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
  }
  
  @IBOutlet var bookTitleLabel: UILabel!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var bookAuthorLabel: UILabel!
  @IBOutlet var bookSynopsisLabel: UILabel!
  
  var book: Book?
  var bookController: BookController?
}
