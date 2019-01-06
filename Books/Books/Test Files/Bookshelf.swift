//
//  Bookshelves.swift
//  Books
//
//  Created by Sergey Osipyan on 1/3/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
// https://www.googleapis.com/books/v1/mylibrary/bookshelves/

import Foundation

struct Bookshelf: Codable {
    
    struct Booksshelf: Codable {
        let items: [Bookshelf]
    }
    
    struct Bookshelf: Codable {
        
        let volumeInfo: VolumeInfo?
        let title: String?
        let volumeCount: Int?
        let id: Int
        
        struct VolumeInfo: Codable {
            let title: String
            let imageLinks: ImageLink?
            
            struct ImageLink: Codable {
                let thumbnail: String
            }
        }
}
}
