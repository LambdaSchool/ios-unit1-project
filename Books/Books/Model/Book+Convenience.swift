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
//    convenience init(title: String, authors: [String] , context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//
//        self.init(context: context)
//
//        self.title = title
//        self.authorsString = authors.joined(separator: ", ")
//    }
    
        /*
            Don't need the convenience init() above b/c we're not manually creating a book with a title and authors.
     We're only creating the book with searchResult so the title and authors can be set directly in the convenience init(searchResult:)
        */
    
    
    convenience init?(searchResult: SearchResult, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
//        self.init(title: searchResult.title, authors: searchResult.authors, context: context)
        
        self.init(context: context)
        
        self.title = searchResult.title
        self.authorsString = searchResult.authors.joined(separator: ", ")
    }
}
