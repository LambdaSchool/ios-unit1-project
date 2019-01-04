//
//  BookDetailViewController.swift
//  BookShelf
//
//  Created by Austin Cole on 1/2/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    var book: Book?
    var indexPath: IndexPath?
    var bookshelves: [Bookshelf]?
    var selectiveBookshelfTVC: SelectiveBookshelfTableViewController?
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var userReviewTextView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var hasReadLabel: UILabel!
    @IBOutlet weak var hasReadSwitch: UISwitch!
    @IBOutlet weak var insertRemoveSegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let book = book else {return}
        bookImageView.image = UIImage(named: "book_image_not_available")
        if let imageURL = book.imageLinks?.smallThumbnail{
            guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
            guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
            bookImageView.image = UIImage(data: imageData)
        }
            
        else if let imageURL = book.imageLinks?.thumbnail {
            guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
            guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
            bookImageView.image = UIImage(data: imageData)
        }
        bookTitleLabel.text = book.title
        hasReadSwitch.isOn = Model.shared.hasRead(book: book)
    }
    @IBAction func insertRemoveAction(_ sender: Any) {
        guard let book = book else {return}
        switch insertRemoveSegmentedControl.selectedSegmentIndex {
        case 0:
            SelectiveBookshelfTableViewController.shared.bookshelves = Model.shared.insertBook(book: book)
            SelectiveBookshelfTableViewController.shared.tableView.reloadData()
        case 1:
            SelectiveBookshelfTableViewController.shared.bookshelves = Model.shared.insertBook(book: book)
            SelectiveBookshelfTableViewController.shared.tableView.reloadData()
        default:
            return
        }
    }
    @IBAction func updateAction(_ sender: Any) {
        guard let text = userReviewTextView.text else {return}
        guard let bookTitle = book?.title else {return}
        Model.shared.saveReview(bookTitle: bookTitle, review: text)
    }
    @IBAction func hasReadSwitchAction(_ sender: Any) {

    }
}
