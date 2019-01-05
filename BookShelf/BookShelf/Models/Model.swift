import UIKit

class Model {
    static let shared = Model()
    private init() {}
    
    let googleBooksAPI = GoogleBooksAPINetworkingClient()
    var bookSearchCVC: BookSearchCollectionViewController?
    var volumes: Volumes?
    var bookshelves: Bookshelves?
    var favoritesBookshelf: Bookshelf?
    var alreadyReadBookshelf: Bookshelf?
    var wantToBuyBookshelf: Bookshelf?
    var wantToReadBookshelf: Bookshelf?
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
    func createBookShelves(bookshelf: BookshelfSelections, book: Book) {
    }
    func addVolume(book: Book, bookshelf: BookshelfSelections) {
        switch bookshelf {
        case .alreadyRead:
            alreadyReadBookshelf?.books?.append(book)
        case .favorites:
            favoritesBookshelf?.books?.append(book)
        case .wantToBuy:
            wantToBuyBookshelf?.books?.append(book)
        case .wantToRead:
            wantToReadBookshelf?.books?.append(book)
        }
    }
    func removeVolume(book: Book, bookshelf: BookshelfSelections) {
        switch bookshelf {
        case .alreadyRead:
            alreadyReadBookshelf?.books = alreadyReadBookshelf?.books?.filter( { $0.title != book.title} )
        case .favorites:
            favoritesBookshelf?.books =  favoritesBookshelf?.books?.filter( { $0.title != book.title} )
        case .wantToBuy:
            wantToBuyBookshelf?.books = wantToBuyBookshelf?.books?.filter( { $0.title != book.title} )
        case .wantToRead:
            wantToReadBookshelf?.books = wantToReadBookshelf?.books?.filter( { $0.title != book.title} )
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
            if alreadyReadBookshelf?.books != nil {
            guard let imageURL = alreadyReadBookshelf?.books?.randomElement()?.imageLinks?.thumbnail else{fatalError("Could not get imageURL")}
                        guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
                        guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
                        guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
                        return image
            }
        case .favorites:
            if favoritesBookshelf?.books != nil {
            guard let imageURL = favoritesBookshelf?.books?.randomElement()?.imageLinks?.thumbnail else{fatalError("Could not get imageURL")}
                    guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
                    guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
                    guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
                    return image
            }
        case .wantToBuy:
            if wantToBuyBookshelf?.books != nil {
                guard let imageURL = wantToBuyBookshelf?.books?.randomElement()?.imageLinks?.thumbnail else{fatalError("Could not get imageURL")}
                    guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
                    guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
                    guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
                    return image
            }
        case .wantToRead:
                if wantToReadBookshelf?.books != nil {
                    guard let imageURL = wantToReadBookshelf?.books?.randomElement()?.imageLinks?.thumbnail else{fatalError("Could not get imageURL")}
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

