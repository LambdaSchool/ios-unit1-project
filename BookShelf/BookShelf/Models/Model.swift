import UIKit

class Model {
    static let shared = Model()
    private init() {}
    
    let googleBooksAPI = GoogleBooksAPINetworkingClient()
    var bookSearchCVC: BookSearchCollectionViewController?
    var volumes: Volumes?
    var bookshelves: Bookshelves?
    var favoritesBookshelf = Bookshelf.init(name: "Favorites", books: [])
    var alreadyReadBookshelf = Bookshelf.init(name: "Already Read", books: [])
    var wantToBuyBookshelf = Bookshelf.init(name: "Want to Buy", books: [])
    var wantToReadBookshelf = Bookshelf.init(name: "Want to Read", books: [])
    var reviewsDictionary: [String:String] = [:]
    
    enum BookshelfSelections {
        case favorites
        case alreadyRead
        case wantToRead
        case wantToBuy
        
    }
    
    func numberOfVolumes() -> Int {
        return volumes?.items.count ?? 10
    }
    func editBookShelves() {
        bookshelves?.bookshelves.removeAll()
        bookshelves?.bookshelves.append(alreadyReadBookshelf)
        bookshelves?.bookshelves.append(favoritesBookshelf)
        bookshelves?.bookshelves.append(wantToBuyBookshelf)
        bookshelves?.bookshelves.append(wantToReadBookshelf)
    }
    func addVolume(book: Book, bookshelf: BookshelfSelections) {
        switch bookshelf {
        case .alreadyRead:
            alreadyReadBookshelf.books.append(book)
        case .favorites:
            print(book)
            favoritesBookshelf.books.append(book)
            print(favoritesBookshelf.books)
        case .wantToBuy:
            wantToBuyBookshelf.books.append(book)
        case .wantToRead:
            wantToReadBookshelf.books.append(book)
        }
    }
    func removeVolume(book: Book, bookshelf: BookshelfSelections) {
        switch bookshelf {
        case .alreadyRead:
            alreadyReadBookshelf.books = alreadyReadBookshelf.books.filter( { $0.title != book.title} )
        case .favorites:
            favoritesBookshelf.books =  favoritesBookshelf.books.filter( { $0.title != book.title} )
        case .wantToBuy:
            wantToBuyBookshelf.books = wantToBuyBookshelf.books.filter( { $0.title != book.title} )
        case .wantToRead:
            wantToReadBookshelf.books = wantToReadBookshelf.books.filter( { $0.title != book.title} )
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
            if alreadyReadBookshelf.books.count != 0 {
                guard let imageURL = alreadyReadBookshelf.books.randomElement()?.imageLinks?.thumbnail else{fatalError("Could not get imageURL")}
                        guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
                        guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
                        guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
                        return image
            }
        case .favorites:
            if favoritesBookshelf.books.count != 0 {
                guard let imageURL = favoritesBookshelf.books.randomElement()?.imageLinks?.thumbnail else{fatalError("Could not get imageURL")}
                    guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
                    guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
                    guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
                    return image
            }
        case .wantToBuy:
            if wantToBuyBookshelf.books.count != 0 {
                guard let imageURL = wantToBuyBookshelf.books.randomElement()?.imageLinks?.thumbnail else{fatalError("Could not get imageURL")}
                    guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
                    guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
                    guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
                    return image
            }
        case .wantToRead:
            if wantToReadBookshelf.books.count != 0{
                guard let imageURL = wantToReadBookshelf.books.randomElement()?.imageLinks?.thumbnail else{fatalError("Could not get imageURL")}
                    guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
                    guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
                    guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
                    return image
                }
        }
        return UIImage(named: "book_image_not_available")
    }
    func saveReview(bookTitle: String, review: String) {
        reviewsDictionary[bookTitle] = review
    }
    func getReview(bookTitle: String) -> String {
        guard let returnValue = reviewsDictionary[bookTitle] else {return ""}
        return returnValue
    }
}

