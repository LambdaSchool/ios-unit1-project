//
//  Bookshelf.swift
//  Books
//
//  Created by Sergey Osipyan on 1/5/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import Foundation

class ModelBookshelf {
    
    static let shared = ModelBookshelf()
    private init() {}
    
    var bookshelf: BookshelfJson? {
        didSet {
            ModelBookshelf.shared.bookshelf = self.bookshelf
        }
    }
    
    func addNewBookshelf() {
        guard let bookshelf = bookshelf else {return}
        booksshelf.append(bookshelf)
        
    }
    
    private(set) var booksshelf: [BookshelfJson] = []
    
    func bookPerformSearch () {
        let url = URL(string: "https://www.googleapis.com/books/v1/mylibrary/bookshelves")!
        let request = URLRequest(url: url)

        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in

            if let error = error {
                NSLog("Error adding authorization to request: \(error)")
                return
            }
            guard let request = request else { return }

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
                    
                    let searchResults = try jsonDecoder.decode(BookshelfJson.self , from: data)
                    
                    self.bookshelf = searchResults
                    // Model.shared.book = searchResults
                    print(searchResults)
                   // completion(nil)
                    return
                } catch {
                    NSLog("Unable to decode data \(error)")
                   // completion(nil)
                    return
                }
                }.resume()
        }
}

}
