import Foundation

class GoogleBooksAPINetworkingClient {
    var books: Books? {
        didSet {
            Model.shared.books = self.books
        }
    }
    
    let baseURL = URL(fileURLWithPath: "https://www.googleapis.com/books/v1/volumes")
    func fetchBooks(searchQuery: String, completion: @escaping (Error?) -> Void) {
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let searchQueryItems = URLQueryItem(name: "q", value: searchQuery)
        
        components?.queryItems = [searchQueryItems]
        
        guard let requestURL = components?.url else {NSLog("failed to request URL using \(components) ")
            completion(NSError())
            return
        }
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                completion(error)
                return
        }
            guard let data = data else {
                completion(NSError())
                NSLog("Failed to get data in fetchBooks method.")
                return
            }
            do {
              let books = try JSONDecoder().decode(Books.self, from: data)
                self.books = books
                completion(nil)
                return
            }catch {
                NSLog("Could not decode data: \(error)")
            }
        }.resume()
    }
}
