//
//  Book+Convenience.swift
//  Books
//
//  Created by Linh Bouniol on 8/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation
import CoreData

extension Book {
    convenience init(title: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.title = title
    }
    
    convenience init?(searchResult: SearchResult, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(title: searchResult.title, context: context)
    }
}
