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
        alreadyReadBookshelfImage.image = Model.shared.getImage(bookshelf: .alreadyRead)
        
        favoritesBookshelfImage.image = Model.shared.getImage(bookshelf: .favorites)
        
        wantToBuyBookshelfImage.image = Model.shared.getImage(bookshelf: .wantToBuy)
        
        wantToReadBookshelfImage.image = Model.shared.getImage(bookshelf: .wantToRead)
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
            let boolean = Model.shared.bookshelves.contains{ $0.name == "Favorites"}
            if boolean == false {
                Model.shared.createBookShelves(bookshelf: .favorites, book: book)
            }
            else {
                var filteredFavorites = Model.shared.bookshelves.filter{ $0.name == "Favorites"}
                filteredFavorites[0].books?.append(book)
            }
        case false:
            var index = -1
            let boolean = Model.shared.bookshelves.contains{ $0.name == "Favorites"}
            if boolean == true {
                for bookshelf in Model.shared.bookshelves {
                    index += 1
                    if bookshelf.name == "Favorites" {
                        break
                    }
                }
                Model.shared.bookshelves[index].books = Model.shared.bookshelves[index].books?.filter{ $0.title != book.title}
            }
            else {
                return
            }
        }
        
    }
    @IBAction func alreadyReadSwitchAction(_ sender: Any) {
        guard let book = book else {return}
        switch alreadyReadBookshelfSwitch.isOn {
        case true:
            let boolean = Model.shared.bookshelves.contains{ $0.name == "Already Read"}
            if boolean == false {
                Model.shared.createBookShelves(bookshelf: .alreadyRead, book: book)
            }
            else {
                var filteredAlreadyRead = Model.shared.bookshelves.filter{ $0.name == "Already Read"}
                filteredAlreadyRead[0].books?.append(book)
            }
        case false:
            var index = -1
            let boolean = Model.shared.bookshelves.contains{ $0.name == "Already Read"}
            if boolean == true {
                for bookshelf in Model.shared.bookshelves {
                    index += 1
                    if bookshelf.name == "Already Read" {
                        break
                    }
                }
                Model.shared.bookshelves[index].books = Model.shared.bookshelves[index].books?.filter{ $0.title != book.title}
            }
            else {
                return
            }
        }
    }
    @IBAction func wantToReadSwitchAction(_ sender: Any) {
        guard let book = book else {return}
        switch wantToReadBookshelfSwitch.isOn {
        case true:
            let boolean = Model.shared.bookshelves.contains{ $0.name == "Want to Read"}
            if boolean == false {
                Model.shared.createBookShelves(bookshelf: .wantToRead, book: book)
            }
            else {
                var filteredWantToRead = Model.shared.bookshelves.filter{ $0.name == "Want to Read"}
                filteredWantToRead[0].books?.append(book)
            }
        case false:
            var index = -1
            let boolean = Model.shared.bookshelves.contains{ $0.name == "Want to Read"}
            if boolean == true {
                for bookshelf in Model.shared.bookshelves {
                    index += 1
                    if bookshelf.name == "Want to Read" {
                        break
                    }
                }
                Model.shared.bookshelves[index].books = Model.shared.bookshelves[index].books?.filter{ $0.title != book.title}
            }
            else {
                return
            }
        }
        
    }
    @IBAction func wantToBuySwitchAction(_ sender: Any) {
        guard let book = book else {return}
        switch favoritesBookshelfSwitch.isOn {
        case true:
            let boolean = Model.shared.bookshelves.contains{ $0.name == "Want to Buy"}
            if boolean == false {
                Model.shared.createBookShelves(bookshelf: .wantToBuy, book: book)
            }
            else {
                var filteredWantToBuy = Model.shared.bookshelves.filter{ $0.name == "Want to Buy"}
                filteredWantToBuy[0].books?.append(book)
                    
            }
        case false:
            var index = -1
            let boolean = Model.shared.bookshelves.contains{ $0.name == "Want to Buy"}
            if boolean == true {
                for bookshelf in Model.shared.bookshelves {
                    index += 1
                    if bookshelf.name == "Want to Buy" {
                        break
                    }
                }
                Model.shared.bookshelves[index].books = Model.shared.bookshelves[index].books?.filter{ $0.title != book.title}
            }
            else {
                return
            }
        }
    }
}
