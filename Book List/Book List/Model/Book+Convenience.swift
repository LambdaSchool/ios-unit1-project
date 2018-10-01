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
    
    /// Convenience initializer for making a Book with the necessary properties
    convenience init (title: String, id: String, author: String?, pageCount: Int16, description: String?, thumbnailURL: String? = nil, imageURL: String? = nil, thumbnailData: Data? = nil, imageData: Data? = nil, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.id = id
        self.author = author
        self.pageCount = pageCount
        self.bookDescription = description
        self.thumbnailURL = thumbnailURL
        self.imageURL = imageURL
        self.thumbnailData = thumbnailData
        self.imageData = imageData
    }
    
    /// Convenienve initializer for making a book from a book representation
    convenience init (bookRepresentation: BookRepresentation, bookshelf: Bookshelf? = nil, context: NSManagedObjectContext) {
        let author = bookRepresentation.volumeInfo.authors?.joined(separator: ", ")
        self.init(title: bookRepresentation.volumeInfo.title,
                  id: bookRepresentation.id,
                  author: author,
                  pageCount: bookRepresentation.volumeInfo.pageCount ?? 0,
                  description: bookRepresentation.volumeInfo.description,
                  thumbnailURL: bookRepresentation.volumeInfo.imageLinks?.thumbnail,
                  imageURL: bookRepresentation.volumeInfo.imageLinks?.biggestImage,
                  thumbnailData: bookRepresentation.thumbnailData,
                  imageData: bookRepresentation.imageData,
                  context: context)
        
        if let bookshelf = bookshelf {
            self.addToBookshelves(bookshelf)
            bookshelf.addToBooks(self)
        }
    }
    
    /// Returns a list of the book's bookshelves as a string.
    var bookshelfList: String {
        var string = ""
        guard let bookshelves = bookshelves else { return string }
        for bookshelf in bookshelves {
            if let bookshelf = bookshelf as? Bookshelf, let title = bookshelf.title {
                string += "\(title)\n"
            }
        }
        return string
    }
}
