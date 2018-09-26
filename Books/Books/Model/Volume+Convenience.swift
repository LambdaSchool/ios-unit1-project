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
    
    convenience init(volumeRepresentation: VolumeRepresentation, hasRead: Bool = false, myRating: Int = 1, myReview: String = "", context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = volumeRepresentation.id
        self.title = volumeRepresentation.volumeInfo.title
        self.subtitle = volumeRepresentation.volumeInfo.subtitle
        self.image = volumeRepresentation.volumeInfo.imageLinks.thumbnail
        self.authors = volumeRepresentation.volumeInfo.authors.joined(separator: ", ")
        self.hasRead = hasRead
        self.myRating = Int16(myRating)
        self.myReview = myReview
    }
}
