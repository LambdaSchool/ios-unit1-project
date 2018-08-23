//
//  CoreDataManager.swift
//  ios-google-books
//
//  Created by Conner on 8/21/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
  static let shared = CoreDataManager()
  
  lazy var container: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Books")
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error {
        fatalError("Error loading stores: \(error)")
      }
    })
    
    container.viewContext.automaticallyMergesChangesFromParent = true
    
    return container
  }()
  
  var mainContext: NSManagedObjectContext {
    return container.viewContext
  }
}
