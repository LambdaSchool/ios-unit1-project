//
//  CoreDataStack.swift
//  Books
//
//  Created by Andrew Dhan on 8/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "Book")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Error loading persistent store")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}
