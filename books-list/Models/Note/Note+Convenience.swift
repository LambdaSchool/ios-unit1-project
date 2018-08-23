//
//  Note+Convenience.swift
//  books-list
//
//  Created by De MicheliStefano on 23.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

extension Note {
    
    convenience init(text: String, timestamp: Date = Date(), identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.text = text
        self.identifier = identifier
        self.timestamp = timestamp
    }
    
}
