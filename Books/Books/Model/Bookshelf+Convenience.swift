//
//  Bookshelf+Convenience.swift
//  Books
//
//  Created by Linh Bouniol on 8/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation
import CoreData

extension Bookshelf {
    
    convenience init(name: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.name = name
        self.sectionText = "iPhone Bookshelves"
    }
    
    @discardableResult
    convenience init?(bookshelfRepresentation: BookshelfRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.name = bookshelfRepresentation.title
        self.identifier = bookshelfRepresentation.id as NSNumber
        self.sectionText = "Google Bookshelves"
    }
}
