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
        bookshelves.append(favoritesBookshelf)
        switch bookshelf {
        case .favorites:
            bookshelves.append(Bookshelf.init(name: "Favorites", books: [book]))
        case .alreadyRead:
            bookshelves.append(Bookshelf.init(name: "Already Read", books: [book]))
        case .wantToRead:
            bookshelves.append(Bookshelf.init(name: "Want to Read", books: [book]))
        case .wantToBuy:
            bookshelves.append(Bookshelf.init(name: "Want to Buy", books: [book]))
            bookshelves.sort { (bookshelf1, bookshelf2) -> Bool in
                bookshelf1.name < bookshelf2.name
            }
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
            
            guard let imageURL = alreadyReadBookshelf?.books?.randomElement()?.imageLinks?.thumbnail else{fatalError("Could not get imageURL")}
                        guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
                        guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
                        guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
                        return image
    
            
        case .favorites:
            
            guard let imageURL = favoritesBookshelf?.books?.randomElement()?.imageLinks?.thumbnail else{fatalError("Could not get imageURL")}
                    guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
                    guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
                    guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
                    return image
            
        case .wantToBuy:

guard let imageURL = wantToBuyBookshelf?.books?.randomElement()?.imageLinks?.thumbnail else{fatalError("Could not get imageURL")}
                    guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
                    guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
                    guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
                    return image
            
        case .wantToRead:

guard let imageURL = wantToReadBookshelf?.books?.randomElement()?.imageLinks?.thumbnail else{fatalError("Could not get imageURL")}
                    guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
                    guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
                    guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
                    return image
            
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

