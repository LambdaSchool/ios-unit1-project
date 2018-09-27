//
//  Bookshelf+Convenience.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation
import CoreData

extension Bookshelf {
    /// Convenience initializer for making a bookshelf with the necessary properties
    convenience init(title: String, id: Int16, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.title = title
        self.id = id
        
        if id == 1 || id == 5 || id == 6 || id == 7 || id == 8 || id == 9 {
            self.editable = false
        } else {
            self.editable = true
        }
    }
    
    /// Convenience initializer for making a bookshelf from a bookshelf representation
    convenience init(bookshelfRepresentation: BookshelfRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(title: bookshelfRepresentation.title, id: bookshelfRepresentation.id, context: context)
    }
    
    /// Checks to see if the given book is in a bookshelf's books set
    func containsBook(_ book: Book) -> Bool {
        guard let books = books  else { return false }
        
        return books.contains(book)
    }
}
