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
    convenience init (title: String, id: String, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.title = title
        self.id = id
    }
    
    convenience init (bookRepresentation: BookRepresentation, bookShelf: Bookshelf? = nil, context: NSManagedObjectContext) {
        self.init(title: bookRepresentation.volumeInfo.title, id: bookRepresentation.id, context: context)
        
        if let bookshelf = bookShelf {
            self.addToBookshelves(bookshelf)
            bookshelf.addToBooks(self)
        }
    }
}
