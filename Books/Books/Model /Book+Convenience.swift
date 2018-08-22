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
                     volumeID: String,
                     shelfID: Int,
                     author: String,
                     haveRead: Bool = false,
                     review: String = "",
                     imagePath: String,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        self.init(context: context)
        
        self.title = title
        self.volumeID = volumeID
        self.shelfID = Int16(shelfID)
        self.author = author
        self.haveRead = haveRead
        self.review = review
        self.imagePath = imagePath
    }
    
    @discardableResult convenience init?(bookRepresentation: BookRepresentation, shelfID: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(context: context)
        
        self.title = bookRepresentation.volumeInfo.title
        self.volumeID = bookRepresentation.id
        self.shelfID = Int16(shelfID)
        self.author = bookRepresentation.volumeInfo.authors?.first
        self.haveRead = shelfID == 4 ? true : false
        self.review = ""
        self.imagePath = bookRepresentation.volumeInfo.imageLinks?.values.first
        
    }
    
}
