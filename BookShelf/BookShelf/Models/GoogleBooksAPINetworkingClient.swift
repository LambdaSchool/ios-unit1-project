import Foundation

class GoogleBooksAPINetworkingClient {
    var volumes: Volumes? {
        didSet {
            Model.shared.volumes = self.volumes
        }
    }
    
    let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes")
    func fetchBooks(searchQuery: String, completion: @escaping (Error?) -> Void) {
        
        var components = URLComponents(url: baseURL!, resolvingAgainstBaseURL: true)
        
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
              let volumes = try JSONDecoder().decode(Volumes.self, from: data)
                self.volumes = volumes
                completion(nil)
                return
            }catch {
                NSLog("Could not decode data: \(error)")
            }
        }.resume()
    }
}
