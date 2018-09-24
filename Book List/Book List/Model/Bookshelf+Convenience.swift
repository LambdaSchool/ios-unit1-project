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
    convenience init(title: String, id: Int16, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.title = title
        self.id = id
    }
    
    convenience init(bookshelfRepresentation: BookshelfRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(title: bookshelfRepresentation.title, id: bookshelfRepresentation.id, context: context)
    }
    
    func containsBook(_ book: Book) -> Bool {
        guard let books = books  else { return false }
        
        return books.contains(book)
    }
}
