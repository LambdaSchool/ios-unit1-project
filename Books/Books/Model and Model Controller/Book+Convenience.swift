//
//  Book+Convenience.swift
//  Books
//
//  Created by Andrew Liao on 8/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import Foundation
import CoreData

extension Book {
    convenience init(title: String,
                     isRead: Bool,
                     review: String = "",
                     imagePath: String?,
                     identifier: UUID = UUID(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        self.init(context: context)
        
        self.title = title
        self.isRead = isRead
        self.review = review
        self.imagePath = imagePath
        self.identifier = identifier
        
    }
    
}
