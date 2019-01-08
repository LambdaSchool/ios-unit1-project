import UIKit

class Model {
    static let shared = Model()
    private init() {}
    
    let googleBooksAPI = GoogleBooksAPINetworkingClient()
    var bookSearchCVC: BookSearchCollectionViewController?
    var volumes: Volumes?
    var bookshelves = Bookshelves.init(recordIdentifier: "", bookshelves: [])
    var alreadyReadBookshelf = Bookshelf.init(name: "Already Read", books: [])
    var favoritesBookshelf = Bookshelf.init(name: "Favorites", books: [])
    var recommendedBookshelf = Bookshelf.init(name: "Recommended", books: [])
    var wantToBuyBookshelf = Bookshelf.init(name: "Want to Buy", books: [])
    var wantToReadBookshelf = Bookshelf.init(name: "Want to Read", books: [])
    var reviewsDictionary: [String:String] = [:]
    
    enum BookshelfSelections {
        case alreadyRead
        case favorites
        case recommended
        case wantToRead
        case wantToBuy
        
    }
    
    func numberOfVolumes() -> Int {
        return volumes?.items.count ?? 10
    }
    func isInBookshelf(book: Book, bookshelf: BookshelfSelections) -> Bool {
        var boolean = false
        switch bookshelf {
        case .alreadyRead:
            boolean = (alreadyReadBookshelf.books?.contains{ $0.title == book.title })!
            return boolean
        case .favorites:
            boolean = (favoritesBookshelf.books?.contains{ $0.title == book.title })!
            return boolean
        case .recommended:
            boolean = (recommendedBookshelf.books?.contains{ $0.title == book.title })!
            return boolean
        case .wantToBuy:
            boolean = (wantToBuyBookshelf.books?.contains{ $0.title == book.title })!
            return boolean
        case .wantToRead:
            boolean = (wantToReadBookshelf.books?.contains{ $0.title == book.title })!
            return boolean
        }
    }
    func addVolume(book: Book, bookshelf: BookshelfSelections) {
        switch bookshelf {
        case .alreadyRead:
            alreadyReadBookshelf.books?.append(book)
        case .favorites:
            favoritesBookshelf.books?.append(book)
        case .recommended:
            print(bookshelves.recordIdentifier)
            recommendedBookshelf.books?.append(book)
        case .wantToBuy:
            wantToBuyBookshelf.books?.append(book)
        case .wantToRead:
            wantToReadBookshelf.books?.append(book)
        }
    }
    func removeVolume(book: Book, bookshelf: BookshelfSelections) {
        switch bookshelf {
        case .alreadyRead:
            alreadyReadBookshelf.books = alreadyReadBookshelf.books?.filter( { $0.title != book.title} )
        case .favorites:
            let favoriteBooks =  favoritesBookshelf.books?.filter( { $0.title != book.title} )
            favoritesBookshelf.books = favoriteBooks
        case .recommended:
            let recommendedBookshelfBooks = recommendedBookshelf.books!.filter( { $0.title != book.title} )
            recommendedBookshelf.books = recommendedBookshelfBooks
        case .wantToBuy:
            wantToBuyBookshelf.books = wantToBuyBookshelf.books?.filter( { $0.title != book.title} )
        case .wantToRead:
            wantToReadBookshelf.books = wantToReadBookshelf.books?.filter( { $0.title != book.title} )
        }
    }
    func searchForBooks(searchTerm: String, completionHandler: @escaping () -> Void) {
        googleBooksAPI.fetchBooks(searchQuery: searchTerm) { error in
            if let error = error {
                fatalError("Could not fetchBooks in Model.searchForBooks: \(error)")
            }
        }
    }
    func getImage(bookshelf: BookshelfSelections) -> UIImage? {
        switch bookshelf {
            
        case .alreadyRead:
            if alreadyReadBookshelf.books?.count != 0 {
                if let imageURL = alreadyReadBookshelf.books?.randomElement()?.imageLinks?.thumbnail {
                        guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
                        guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
                        guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
                        return image
                }
            }
        case .favorites:
            if favoritesBookshelf.books?.count != 0 {
                if let imageURL = favoritesBookshelf.books?.randomElement()?.imageLinks?.thumbnail {
                    guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
                    guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
                    guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
                    return image
                }
            }
        case .recommended:
            if recommendedBookshelf.books?.count != 0 {
                if let imageURL = recommendedBookshelf.books!.randomElement()?.imageLinks?.thumbnail {
                    guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
                    guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
                    guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
                    return image
                }
            }
        case .wantToBuy:
            if wantToBuyBookshelf.books?.count != 0 {
                if let imageURL = wantToBuyBookshelf.books?.randomElement()?.imageLinks?.thumbnail {
                    guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
                    guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
                    guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
                    return image
                }
            }
        case .wantToRead:
            if wantToReadBookshelf.books?.count != 0{
                if let imageURL = wantToReadBookshelf.books?.randomElement()?.imageLinks?.thumbnail {
                    guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
                    guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
                    guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
                    return image
                    }
                }
        }
        return UIImage(named: "book_image_not_available")
    }
    func saveReview(bookTitle: String, review: String) {
        reviewsDictionary[bookTitle] = review
    }
    func loadReview(bookTitle: String) -> String {
        guard let returnValue = reviewsDictionary[bookTitle] else {return ""}
        return returnValue
    }
    func getBookshelves() {
        Firebase.fetchRecords { (bookshelves) in}
}
    func updateBookshelves() {
        bookshelves.bookshelves.removeAll()
        bookshelves.bookshelves.append(alreadyReadBookshelf)
        bookshelves.bookshelves.append(favoritesBookshelf)
        bookshelves.bookshelves.append(wantToBuyBookshelf)
        bookshelves.bookshelves.append(wantToReadBookshelf)
        bookshelves.bookshelves.append(recommendedBookshelf)
        Firebase.save(bookshelves: bookshelves)
    }
}

