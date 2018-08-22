//
//  Collection+Convenience.swift
//  books-list
//
//  Created by De MicheliStefano on 22.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

extension Collection {
    
    convenience init(identifier: String, title: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.title = title
    }
    
    convenience init?(collectionRepresentation: CollectionRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(identifier: String(collectionRepresentation.identifier),
                  title: collectionRepresentation.title,
                  context: context)
    }
    
}
