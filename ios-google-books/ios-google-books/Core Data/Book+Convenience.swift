//
//  Book+Convenience.swift
//  ios-google-books
//
//  Created by Conner on 8/21/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation
import CoreData

extension Book {
  convenience init(title: String,
                   author: String,
                   synopsis: String,
                   hasRead: Bool,
                   id: String,
                   thumbnail: NSData,
                   review: String,
                   context: NSManagedObjectContext = CoreDataManager.shared.mainContext) {
    self.init(context: context)
    
    self.title = title
    self.author = author
    self.synopsis = synopsis
    self.hasRead = hasRead
    self.id = id
    self.thumbnail = thumbnail as Data
    self.review = review
  }
}
