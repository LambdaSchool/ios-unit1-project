//
//  CoreDataStack.swift
//  books-list
//
//  Created by De MicheliStefano on 21.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

    enum CoreDataModels: String {
        case Book
    }
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataModels.Book.rawValue)
        container.loadPersistentStores  { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext) -> Error? {
        var error: Error?
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        return error != nil ? error: nil
    }
    
}

