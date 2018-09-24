//
//  Book.swift
//  Books
//
//  Created by Farhan on 9/24/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation

struct Book{
    struct volumeInfo{
        let title: String?
        let description:String?
        let pageCount: Int?
        let authors: [String]
        let averageRating: Int?
        struct imageLinks{
            let thumbnail: String?
        }
    }
    
}

struct SearchResults{
    var items: [Book]
}
