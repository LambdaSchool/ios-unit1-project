import Foundation

class Firebase<Item: Codable > {
    enum Methods {
        case get
        case post
        case put
        case delete
    }
    private var baseURL: URL!  { return URL(string: "https://bookshelf-67481.firebaseio.com/") }
    
    private func requestURL(_ method: Methods, for recordIdentifier: String = "unknownid") -> URL {
        switch method {
        case .get:
            // You post to the main DB. It will return a new record identifier
            return baseURL.appendingPathExtension("json")
        case .post, .put, .delete:
            // These all work on individual records, and you need to use the
            // record identifier in your URL with one exception, which is when
            // all the records at once, in which case, you do not need the record
            // identifier.
            return baseURL
                .appendingPathComponent(recordIdentifier)
                .appendingPathExtension("json")
        default:
            fatalError("Unknown request method: \(method)")
        }
    }
    func fetchBookshelves(bookshelves: Bookshelves, completion: @escaping (Error?) -> Void) {
        let url = requestURL(.get, for: bookshelves.recordIdentifier)
        URLSession.shared.dataTask(with: url) { (data, _, error)  in
            if let error = error {
                NSLog("Error fetching search results.")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("Could not get data")
                completion(NSError())
                return
            }
            do {
              let bookshelves = try JSONDecoder().decode(Bookshelves.self, from: data)
                Model.shared.bookshelves = bookshelves
                completion(nil)
                return
            } catch {
                NSLog("Error decoding JSON: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
}
