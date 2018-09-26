//
//  Book+Convenience.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation
import CoreData

extension Book {
    convenience init (title: String, id: String, author: String?, pageCount: Int16, description: String?, thumbnailURL: String? = nil, imageURL: String? = nil, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.id = id
        self.author = author
        self.pageCount = pageCount
        self.bookDescription = description
        self.thumbnailURL = thumbnailURL
        self.imageURL = imageURL
    }
    
    convenience init (bookRepresentation: BookRepresentation, bookShelf: Bookshelf? = nil, context: NSManagedObjectContext) {
        let author = bookRepresentation.volumeInfo.authors?.joined(separator: ", ")
        self.init(title: bookRepresentation.volumeInfo.title,
                  id: bookRepresentation.id,
                  author: author,
                  pageCount: bookRepresentation.volumeInfo.pageCount ?? 0,
                  description: bookRepresentation.volumeInfo.description,
                  thumbnailURL: bookRepresentation.volumeInfo.imageLinks?.thumbnail,
                  imageURL: bookRepresentation.volumeInfo.imageLinks?.biggestImage,
                  context: context)
        
        if let bookshelf = bookShelf {
            self.addToBookshelves(bookshelf)
            bookshelf.addToBooks(self)
        }
    }
}
