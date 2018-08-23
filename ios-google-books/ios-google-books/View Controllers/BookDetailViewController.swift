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
      
      if let bookReview = book.review {
        if bookReview.count > 0 {
          addReviewButton.setTitle("Read Review", for: .normal)
          markAsReadButton.setTitle("Mark as unread", for: .normal)
        } else if bookReview.count == 0 && book.hasRead {
          addReviewButton.setTitle("Add Review", for: .normal)
          markAsReadButton.setTitle("Mark as unread", for: .normal)
        }
      }
    }
  }
  
  @IBAction func toggleReadStatus(_ sender: Any) {
    if let book = book {
      do {
        try bookController?.toggleRead(book: book)
      } catch {
        NSLog("Error changing book read status")
      }
    }
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddReviewSegue" {
      if let vc = segue.destination as? AddReviewViewController {
        vc.book = book
        vc.bookController = bookController
      }
    }
  }
  
  @IBOutlet var bookTitleLabel: UILabel!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var bookAuthorLabel: UILabel!
  @IBOutlet var bookSynopsisLabel: UILabel!
  @IBOutlet var addReviewButton: UIButton!
  @IBOutlet var markAsReadButton: UIButton!
  
  var book: Book?
  var bookController: BookController?
}
