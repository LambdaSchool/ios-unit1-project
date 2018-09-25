//
//  Bookshelf+Convenience.swift
//  Book List
//
//  Created by Moin Uddin on 9/25/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation
import CoreData

extension Bookshelf {
    convenience init(title: String, id: Int16, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.title = title
        self.id = id
    }
    
    
    convenience init?(bookshelfRepresentation: BookshelfRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(title: bookshelfRepresentation.title, id: bookshelfRepresentation.id, context: context)
    }
    
}
