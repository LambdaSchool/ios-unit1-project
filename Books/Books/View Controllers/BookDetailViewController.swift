//
//  BookDetailViewController.swift
//  Books
//
//  Created by Linh Bouniol on 8/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    var bookController: BookController?
    
    var book: Book? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var bookReviewTextView: UITextView!
    
    @IBAction func submitReview(_ sender: Any) {
        guard let review = bookReviewTextView.text, let book = book else { return }
        bookController?.update(book: book, with: review)
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        guard let book = book, isViewLoaded else { return }
        
        navigationItem.title = book.title
        bookReviewTextView.text = book.review
    }
}
