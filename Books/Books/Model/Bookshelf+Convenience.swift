//
//  Bookshelf+Convenience.swift
//  Books
//
//  Created by Daniela Parra on 9/26/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import CoreData

extension Bookshelf {
    
    @discardableResult convenience init(bookshelfRepresentation: BookshelfRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = bookshelfRepresentation.title
        self.id = Int16(bookshelfRepresentation.id)
    }
}
