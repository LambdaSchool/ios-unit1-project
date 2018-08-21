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
    
    convenience init(title: String, abstract: String, image: Data, hasRead: Bool = false, pages: String, price: String, timestamp: Date = Date(), context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.abstract = abstract
        self.image = image
        self.hasRead = hasRead
        self.pages = pages
        self.price = price
        self.timestamp = timestamp
    }
    
    convenience init?(bookRepresentation: BookRepresentation, context: NSManagedObjectContext) {
        self.init(title: bookRepresentation.title,
                  abstract: bookRepresentation.abstract,
                  image: bookRepresentation.image,
                  hasRead: bookRepresentation.hasRead,
                  pages: bookRepresentation.pages,
                  price: bookRepresentation.price,
                  timestamp: bookRepresentation.timestamp,
                  context: context)
    }
    
}
