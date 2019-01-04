import UIKit

class Model {
    static let shared = Model()
    private init() {}
    
    let googleBooksAPI = GoogleBooksAPINetworkingClient()
    var bookSearchCVC: BookSearchCollectionViewController?
    var volumes: Volumes?
    var bookshelves: [Bookshelf] = []
    let favoritesBookshelf = Bookshelf.init(name: "Favorites", books: nil)
    let alreadyReadBookshelf = Bookshelf.init(name: "Already Read", books: nil)
    let wantToReadBookshelf = Bookshelf.init(name: "Want to Read", books: nil)
    let wantToBuyBookshelf = Bookshelf.init(name: "Want to Buy", books: nil)
    
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
    func getImage(string: String) -> UIImage {
        let imageURL = string
            guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
            guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
            guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
        print(url)
            return image
    }
}
