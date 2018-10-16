//
//  Volume+Convenience.swift
//  Books
//
//  Created by Daniela Parra on 9/25/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import CoreData

extension Volume {
    
    @discardableResult convenience init(volumeRepresentation: VolumeRepresentation, hasRead: Bool = false, myReview: String = "", bookshelf: Bookshelf, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = volumeRepresentation.id
        self.title = volumeRepresentation.volumeInfo.title
        self.subtitle = volumeRepresentation.volumeInfo.subtitle
        self.image = volumeRepresentation.volumeInfo.imageLinks.thumbnail
        self.authors = volumeRepresentation.volumeInfo.authors.joined(separator: ", ")
        self.hasRead = hasRead
        self.myReview = myReview
        bookshelf.addToVolumes(self)
        self.addToBookshelves(bookshelf)
        
    }
}
