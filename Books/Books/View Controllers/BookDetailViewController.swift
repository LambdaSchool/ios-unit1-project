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
    
    @IBOutlet weak var bookCoverView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var releasedDateLabel: UILabel!
    @IBOutlet weak var pagesLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
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
        
        titleLabel.text = book.title
        authorsLabel.text = book.authorsString
        bookReviewTextView.text = book.review
        descriptionTextView.text = book.bookDescription
        releasedDateLabel.text = book.releasedDate
        
        if let pages = book.pages {
            pagesLabel.text = "\(pages) pages"
        } else {
            pagesLabel.text = ""
        }
        
        guard let urlString = book.imageURL else { return }
        guard let url = URL(string: urlString) else { return }
        ImageController.loadImage(at: url) { (image, _) in
            self.bookCoverView.image = image
        }
    }
}
