
import Foundation

class Model {
    static let shared = Model()
    private init() {}
    
    var book: BookModel? {
        didSet {
            Model.shared.book = self.book
        }
    }
    private(set) var books: [BookModel] = []
//    var bookshelves: Bookshelves?
//    var bookshelvess: [Bookshelves] = []
    
    func numberOfBooks() -> Int {
        return books.count
    }
    
    func clearBooks() {
        books = []
    }

    func bookAtIndex(at indexPath: IndexPath) ->  BookModel {
        return books[indexPath.row]
    }
    func book(at index: Int) -> BookModel {
        return books[index]
    }
    
    func addNewBook() {
        guard let book = book else {return}
        books.append(book)
        
    }
    
    func deleteBook(at indexPath: IndexPath) {
        books.remove(at: indexPath.row)
    }
    
    func performSearch (with searchTerm: String, completion: @escaping  (Error?) -> Void) {
        
        guard let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes") else { fatalError("Unable to construct baseURL") }
        
        
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let searchQueryItem = URLQueryItem(name: "q", value: searchTerm)
        let maxQueryItem = URLQueryItem(name: "maxResults", value: "30")
        urlComponents?.queryItems = [searchQueryItem, maxQueryItem]
        
        guard let request1 = urlComponents?.url else {
            NSLog("Error recive URL using \(String(describing: urlComponents)) ")
            completion(NSError())
            return
        }
        var request = URLRequest(url: request1)
        request.httpMethod = "GET"

        
                URLSession.shared.dataTask(with: request) { (data, _, error) in
                    if let error = error {
                        NSLog("Error getting bookshelves: \(error)")
                        return
                    }
                    guard let data = data else { return }
                    
                    if let json = String(data: data, encoding: .utf8) {
                         print(json)
                    }
                
                
                do {
                    let jsonDecoder = JSONDecoder()
                    
                    let searchResults = try jsonDecoder.decode(BookModel.self, from: data)
                    
                    self.book = searchResults
                    // Model.shared.book = searchResults
                    print([searchResults])
                    completion(nil)
                    return
                } catch {
                    NSLog("Unable to decode data \(error)")
                    completion(nil)
                    return
                }
                }.resume()
}
}
