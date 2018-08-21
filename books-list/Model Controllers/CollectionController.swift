//
//  CollectionController.swift
//  books-list
//
//  Created by De MicheliStefano on 22.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

class CollectionController {
    
    
    // MARK: - Properties
    
    
    // MARK: - API Methods
    
    
    // MARK: - Persistence Methods
    
    func create(title: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            let _ = Collection(title: title)
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving collection to persistence")
            }
        }
    }
    
    // MARK: - Private Methods
    
}
