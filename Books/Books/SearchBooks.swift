//import UIKit
//import Foundation
//
//class SearchBooks {
//    
//    var book: BookModel?
//  private(set) var books: [BookModel] = []
//    func performSearch (with searchTerm: String, completion: @escaping  (Error?) -> Void) {
//        
//        guard let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes/?q=" + searchTerm  ) else { fatalError("Unable to construct baseURL") }
//        
//        
//      //  let request = URLRequest(url: baseURL)
//        //var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
//       // let urlComponents = NSURLComponents(url: baseURL, resolvingAgainstBaseURL: true)
//       // let searchQueryItem = URLQueryItem(name: "q", value: searchTerm)
//       // urlComponents?.queryItems = [searchQueryItem]
//        
//        
//        var request = URLRequest(url: baseURL)
//        request.httpMethod = "GET"
//        
//        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
//            if let error = error {
//                NSLog("Error adding authorization to request: \(error)")
//                completion(error)
//                return
//            }
//            guard let request = request else { return }
//            
//            URLSession.shared.dataTask(with: request) { (data, _, error) in
//                if let error = error {
//                    NSLog("Error fetching volumes from Google Books API: \(error)")
//                    completion(error)
//                    return
//                }
//                
//                guard let data = data else {
//                    NSLog("Error fetching volumes")
//                    completion(error)
//                    return
//                }
//                let json = String(data: data, encoding: .utf8)
//                print(json!)
//
//        
//            URLSession.shared.dataTask(with: request) { (data, _, error) in
//                if let error = error {
//                    NSLog("Error getting bookshelves: \(error)")
//                    return
//                }
//                guard let data = data else { return }
//                
//                if let json = String(data: data, encoding: .utf8) {
//                 //   print(json)
//                }
//        }
//    
//            do {
//                let jsonDecoder = JSONDecoder()
//
//                let searchResults = try jsonDecoder.decode(BookModel.self, from: data)
//                
//                  self.book = searchResults
//                // Model.shared.book = searchResults
//                print(searchResults)
//                completion(nil)
//                return
//            } catch {
//                NSLog("Unable to decode data \(error)")
//                completion(nil)
//                return
//            }
//        }.resume()
//    }
//
//}
//}
