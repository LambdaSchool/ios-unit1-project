//
//  Bookshelves.swift
//  Books
//
//  Created by Sergey Osipyan on 1/3/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
// https://www.googleapis.com/books/v1/mylibrary/bookshelves/

import Foundation


    struct BookshelfJson: Codable {
        let items: [Bookshelf]
    
    struct Bookshelf: Codable {
      
        let title: String?
        let volumeCount: Int?
        let id: Int
        
            }

}

