//
//  Book+Convenience.swift
//  books-list
//
//  Created by De MicheliStefano on 21.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

extension Book {
    
    convenience init(identifier: String, title: String, authors: String?, abstract: String?, image: Data? = nil, hasRead: Bool = false, pageCount: String?, averageRating: String?, ratingsCount: String?, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
        self.authors = authors ?? nil
        self.abstract = abstract ?? nil
        self.image = image ?? nil
        self.hasRead = hasRead
        self.pageCount = pageCount ?? nil
        self.averageRating = averageRating ?? nil
        self.ratingsCount = ratingsCount ?? nil
        self.timestamp = timestamp
        //TODO: ISBN
    }
    
    convenience init?(bookRepresentation: BookRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(identifier: bookRepresentation.id,
                  title: bookRepresentation.volumeInfo.title,
                  authors: (bookRepresentation.volumeInfo.authors != nil ? bookRepresentation.volumeInfo.authors!.joined(separator: ", ") : nil)!,
                  abstract: bookRepresentation.volumeInfo.abstract ?? nil,
                  pageCount: bookRepresentation.volumeInfo.pageCount != nil ? String(bookRepresentation.volumeInfo.pageCount!) : nil,
                  averageRating: bookRepresentation.volumeInfo.averageRating != nil ? String(format: "%.1f", bookRepresentation.volumeInfo.averageRating!) : nil,
                  ratingsCount: bookRepresentation.volumeInfo.ratingsCount != nil ? String(bookRepresentation.volumeInfo.ratingsCount!) : nil,
                  context: context)
        
        self.timestamp = Date()
        
        //TODO: ISBN
    }
}
