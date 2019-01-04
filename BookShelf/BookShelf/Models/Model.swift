import UIKit

class Model {
    static let shared = Model()
    private init() {}
    
    let googleBooksAPI = GoogleBooksAPINetworkingClient()
    var bookSearchCVC: BookSearchCollectionViewController?
    var volumes: Volumes?
    var bookshelves: [Bookshelf] = []
    var favoritesBookshelf = Bookshelf.init(name: "Favorites", books: nil)
    var alreadyReadBookshelf = Bookshelf.init(name: "Already Read", books: nil)
    var wantToReadBookshelf = Bookshelf.init(name: "Want to Read", books: nil)
    var wantToBuyBookshelf = Bookshelf.init(name: "Want to Buy", books: nil)
    var reviewsDictionary: [String:String] = [:]
    
    enum BookshelfSelections {
        case favorites
        case alreadyRead
        case wantToRead
        case wantToBuy
        
    }
    
    func numberOfVolumes() -> Int {
        guard let volumes = volumes else {fatalError("Error getting volumes")}
        return volumes.items.count
    }
    func createBookShelves() {
        bookshelves = []
        bookshelves.append(favoritesBookshelf)
        bookshelves.append(alreadyReadBookshelf)
        bookshelves.append(wantToReadBookshelf)
        bookshelves.append(wantToBuyBookshelf)
        
    }
    func searchForBooks(searchTerm: String, completionHandler: @escaping () -> Void) {
        googleBooksAPI.fetchBooks(searchQuery: searchTerm) { error in
            if let error = error {
                fatalError("Could not fetchBooks in Model.searchForBooks: \(error)")
            }
        }
    }
    func getImage(string: String) -> UIImage {
        let imageURL = string
            guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
            guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
            guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
        print(url)
            return image
    }
    func saveReview(bookTitle: String, review: String) {
        reviewsDictionary[bookTitle] = review
    }
    func saveFavorite(favorited: Bool, book: Book, indexPath: IndexPath) {
        if favorited == true {
            favoritesBookshelf.books?.append(book)
        } else {
            favoritesBookshelf.books?.remove(at: indexPath.row)
        }
    }
    func getReview(bookTitle: String) -> String {
        guard let returnValue = reviewsDictionary[bookTitle] else {return ""}
        return returnValue
    }
    func hasRead(book: Book) -> Bool {
        var response = false
        guard let books = alreadyReadBookshelf.books else {return false}
        response = books.contains { (book) -> Bool in
            if book.title == book.title {
                return true
            }
            return false
        }
        return response
    }
    func insertBookToBookshelf(book: Book, bookshelf: BookshelfSelections) {
        switch bookshelf {
        case .favorites:
            favoritesBookshelf.books?.append(book)
        case .alreadyRead:
            alreadyReadBookshelf.books?.append(book)
        case .wantToRead:
            wantToReadBookshelf.books?.append(book)
        case .wantToBuy:
            wantToBuyBookshelf.books?.append(book)
        }
        createBookShelves()
    }
    func removeBookToBookshelf(book: Book, bookshelf: BookshelfSelections) {
        switch bookshelf {
        case .favorites:
            favoritesBookshelf.books = favoritesBookshelf.books?.filter{$0.title != book.title}
        case .alreadyRead:
            alreadyReadBookshelf.books = favoritesBookshelf.books?.filter{$0.title != book.title}
        case .wantToRead:
            wantToReadBookshelf.books = favoritesBookshelf.books?.filter{$0.title != book.title}
        case .wantToBuy:
            wantToBuyBookshelf.books = favoritesBookshelf.books?.filter{$0.title != book.title}
        }
        createBookShelves()
    }
    func loadSwitches(book: Book, bookshelfCases: BookshelfSelections) -> Bool {
        switch bookshelfCases {
        case .favorites:
            guard let books = favoritesBookshelf.books else {fatalError("Could not get book")}
            return books.contains{ $0.title == book.title}
        case .alreadyRead:
            guard let books = alreadyReadBookshelf.books else {fatalError("Could not get book")}
            return books.contains{ $0.title == book.title}
        case .wantToRead:
            guard let books = wantToReadBookshelf.books else {fatalError("Could not get book")}
            return books.contains{ $0.title == book.title}
        case .wantToBuy:
            guard let books = wantToBuyBookshelf.books else {fatalError("Could not get book")}
            return books.contains{ $0.title == book.title}
        }
    }
}
