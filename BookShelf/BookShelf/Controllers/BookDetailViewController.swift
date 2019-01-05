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
    @IBOutlet weak var favoritesBookshelfLabel: UILabel!
    @IBOutlet weak var alreadyReadBookshelfLabel: UILabel!
    @IBOutlet weak var wantToReadBookshelfLabel: UILabel!
    @IBOutlet weak var wantToBuyBookshelfLabel: UILabel!
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
        
            alreadyReadBookshelfImage.image = Model.shared.getImage(bookshelf: .alreadyRead)
            
            favoritesBookshelfImage.image = Model.shared.getImage(bookshelf: .favorites)
            
            wantToBuyBookshelfImage.image = Model.shared.getImage(bookshelf: .wantToBuy)
            
            wantToReadBookshelfImage.image = Model.shared.getImage(bookshelf: .wantToRead)
        
        favoritesBookshelfLabel.text = "Favorites"
        alreadyReadBookshelfLabel.text = "Already Read"
        wantToReadBookshelfLabel.text = "Want to Read"
        wantToBuyBookshelfLabel.text = "Want to Buy"
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let book = book else {return}
        alreadyReadBookshelfImage.image = Model.shared.getImage(bookshelf: .alreadyRead)
        
        favoritesBookshelfImage.image = Model.shared.getImage(bookshelf: .favorites)
        
        wantToBuyBookshelfImage.image = Model.shared.getImage(bookshelf: .wantToBuy)
        
        wantToReadBookshelfImage.image = Model.shared.getImage(bookshelf: .wantToRead)
        
        alreadyReadBookshelfSwitch.isOn = Model.shared.isInBookshelf(book: book, bookshelf: .alreadyRead)
        favoritesBookshelfSwitch.isOn = Model.shared.isInBookshelf(book: book, bookshelf: .favorites)
        wantToReadBookshelfSwitch.isOn = Model.shared.isInBookshelf(book: book, bookshelf: .wantToRead)
        wantToBuyBookshelfSwitch.isOn = Model.shared.isInBookshelf(book: book, bookshelf: .wantToBuy)
    }
    @IBAction func updateAction(_ sender: Any) {
        guard let text = userReviewTextView.text else {return}
        guard let bookTitle = book?.title else {return}
        Model.shared.saveReview(bookTitle: bookTitle, review: text)
    }
    @IBAction func hasReadSwitchAction(_ sender: Any) {

    }
    
    //MARK: Bookshelf switch actions
    @IBAction func favoritesSwitchAction(_ sender: Any) {
        guard let book = book else {return}
        switch favoritesBookshelfSwitch.isOn {
        case true:
            Model.shared.addVolume(book: book, bookshelf: .favorites)
        case false:
            Model.shared.removeVolume(book: book, bookshelf: .favorites)
        }
        
    }
    @IBAction func alreadyReadSwitchAction(_ sender: Any) {
        guard let book = book else {return}
        switch alreadyReadBookshelfSwitch.isOn {
        case true:
            Model.shared.addVolume(book: book, bookshelf: .alreadyRead)
        case false:
            Model.shared.removeVolume(book: book, bookshelf: .alreadyRead)
        }
    }
    @IBAction func wantToReadSwitchAction(_ sender: Any) {
        guard let book = book else {return}
        switch wantToReadBookshelfSwitch.isOn {
        case true:
        Model.shared.addVolume(book: book, bookshelf: .wantToRead)
        case false:
            Model.shared.removeVolume(book: book, bookshelf: .wantToRead)
        }
        
    }
    @IBAction func wantToBuySwitchAction(_ sender: Any) {
        guard let book = book else {return}
        switch wantToBuyBookshelfSwitch.isOn {
        case true:
            Model.shared.addVolume(book: book, bookshelf: .wantToBuy)
        case false:
            Model.shared.removeVolume(book: book, bookshelf: .wantToBuy)
        }
    }
}
