//
//  AddReviewViewController.swift
//  ios-google-books
//
//  Created by Conner on 8/23/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit

class AddReviewViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let book = book {
      bookTitleLabel.text = book.title
      
      guard let bookReview = book.review else { return }
      if bookReview.count > 0 {
        title = "Update Review"
        bookReviewTextView.text = book.review
      }
    }
  }
  
  @IBAction func saveReview(_ sender: Any) {
    guard let bookReview = bookReviewTextView.text else { return }
    if let book = book {
      if !bookReview.isEmpty {
        do {
          try bookController?.updateBook(book: book, review: bookReview)
        } catch {
          NSLog("Error adding review to book")
          return
        }
      }
    }
    let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
    self.navigationController?.popToViewController(controller!, animated: true)
  }
  
  @IBOutlet var bookTitleLabel: UILabel!
  @IBOutlet var bookReviewTextView: UITextView!
  
  var book: Book?
  var bookController: BookController?
}
