import Foundation

class Model {
    static let shared = Model()
    private init() {}
    
    let googleBooksAPI = GoogleBooksAPINetworkingClient()
    var bookSearchCVC: BookSearchCollectionViewController?
    var volumes: Volumes?
    var bookshelves: [Bookshelf] = []
    let favoritesBookshelf = Bookshelf.init(name: "Favorites", volumes: [])
    let alreadyReadBookshelf = Bookshelf.init(name: "Already Read", volumes: [])
    let wantToReadBookshelf = Bookshelf.init(name: "Want to Read", volumes: [])
    let wantToBuyBookshelf = Bookshelf.init(name: "Want to Buy", volumes: [])
    
    func numberOfVolumes() -> Int {
        return volumes?.items.count ?? 0
    }
    func createBookShelves() {
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
}
