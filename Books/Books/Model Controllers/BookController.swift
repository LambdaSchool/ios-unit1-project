//
//  BookController.swift
//  Books
//
//  Created by Linh Bouniol on 8/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation

class BookController {
    
    // MARK: - Properties
    
    var searchResults: [SearchResult] = []
    
    // MARK: - CRUD
    
    func createBook(with searchResult: SearchResult, inBookshelf bookshelf: Bookshelf) {
//        guard let book = Book(searchResult: searchResult) else { return }
        let book = Book(searchResult: searchResult)
        book?.bookshelf = bookshelf
    }
}
