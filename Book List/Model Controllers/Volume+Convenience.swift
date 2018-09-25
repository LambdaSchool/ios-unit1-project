//
//  File.swift
//  Book List
//
//  Created by Moin Uddin on 9/24/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation
import CoreData

extension Volume {
    convenience init(title: String, id: String, hasRead: Bool = false, review: String = "", imageLink: String, context: NSManagedObjectContext =  CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.id = id
        self.hasRead = hasRead
        self.review = review
    }
    
    convenience init?(volumeRepresentation: VolumeRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(title: volumeRepresentation.volumeInfo.title, id: volumeRepresentation.id, hasRead: volumeRepresentation.hasRead!, review: volumeRepresentation.review!, imageLink: volumeRepresentation.volumeInfo.imageLinks.thumbnail)
    }
}
