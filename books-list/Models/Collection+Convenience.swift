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
    
    convenience init(title: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
    }
    
    convenience init?(collectionRepresentation: CollectionRepresentation, context: NSManagedObjectContext) {
        self.init(title: collectionRepresentation.title,
                  context: context)
    }
    
}
