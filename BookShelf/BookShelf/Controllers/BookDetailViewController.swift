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
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var userReviewTextView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var hasReadLabel: UILabel!
    @IBOutlet weak var hasReadSwitch: UISwitch!
    @IBOutlet weak var favoritesBookshelfImage: UIImageView!
    @IBOutlet weak var alreadyReadBookshelfImage: UIImageView!
    @IBOutlet weak var wantToReadBookshelfImage: UIImageView!
    @IBOutlet weak var wantToBuyBookshelfImage: UIImageView!
    @IBOutlet weak var favoritesBookShelfLabel: UILabel!
    @IBOutlet weak var alreadyReadBookShelfLabel: UILabel!
    @IBOutlet weak var wantToReadBookShelfLabel: UILabel!
    @IBOutlet weak var wantToBuyBookShelfLabel: UILabel!
    @IBOutlet weak var favoritesBookshelfSwitch: UISwitch!
    @IBOutlet weak var alreadyReadBookshelfSwitch: UISwitch!
    @IBOutlet weak var wantToReadBookshelfSwitch: UISwitch!
    @IBOutlet weak var wantToBuyBookshelfSwitch: UISwitch!
    
    
    
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
        favoritesBookshelfSwitch.isOn = Model.shared.loadSwitches(book: book, bookshelfCases: .favorites)
        alreadyReadBookshelfSwitch.isOn = Model.shared.loadSwitches(book: book, bookshelfCases: .alreadyRead)
        wantToReadBookshelfSwitch.isOn = Model.shared.loadSwitches(book: book, bookshelfCases: .wantToRead)
        wantToBuyBookshelfSwitch.isOn = Model.shared.loadSwitches(book: book, bookshelfCases: .wantToBuy)
        
        
    }
    @IBAction func updateAction(_ sender: Any) {
        guard let text = userReviewTextView.text else {return}
        guard let bookTitle = book?.title else {return}
        Model.shared.saveReview(bookTitle: bookTitle, review: text)
    }
    @IBAction func hasReadSwitchAction(_ sender: Any) {

    }
    @IBAction func favoritesSwitchAction(_ sender: Any) {
        guard let book = book else {return}
        if favoritesBookshelfSwitch.isOn {
            Model.shared.insertBookToBookshelf(book: book, bookshelf: .favorites)
        }
        
    }
    @IBAction func alreadyReadSwitchAction(_ sender: Any) {
        guard let book = book else {return}
        if alreadyReadBookshelfSwitch.isOn {
            Model.shared.insertBookToBookshelf(book: book, bookshelf: .alreadyRead)
        }
        
    }
    @IBAction func wantToReadSwitchAction(_ sender: Any) {
        guard let book = book else {return}
        if wantToReadBookshelfSwitch.isOn {
            Model.shared.insertBookToBookshelf(book: book, bookshelf: .wantToRead)
        }
        
    }
    @IBAction func wantToBuySwitchAction(_ sender: Any) {
        guard let book = book else {return}
        if wantToBuyBookshelfSwitch.isOn {
            Model.shared.insertBookToBookshelf(book: book, bookshelf: .wantToBuy)
        }
        
    }
}
