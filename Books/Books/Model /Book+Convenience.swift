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
                     isRead: Bool = false,
                     review: String = "",
                     imagePath: String,
                     volumeID: String,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        self.init(context: context)
        
        self.title = title
        self.haveRead = isRead
        self.review = review
        self.imagePath = imagePath
        self.volumeID = volumeID
    }
    
}
