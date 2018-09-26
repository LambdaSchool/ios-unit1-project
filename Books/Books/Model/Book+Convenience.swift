//
//  Book+Convenience.swift
//  Books
//
//  Created by Farhan on 9/25/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation
import CoreData

extension Book {
    
    convenience init(title: String, hasRead: Bool = false, id: String, thumbnail: String?, review: String?, averageRating: Double?, author: String?, publishedDate: String?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        self.init(context: context)
        
        self.title = title
        self.id = id
        self.hasRead = hasRead
        
        self.thumbnail = thumbnail
        self.review = review
        self.averageRating = averageRating ?? 0.0
        self.author = author
        self.publishedDate = publishedDate
        
    }
    
    convenience init?(bookRepresentation: BookRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        
        guard let title = bookRepresentation.volumeInfo.title,
            let id = bookRepresentation.id,
            let author = bookRepresentation.volumeInfo.authors?.first,
            let thumbnail = bookRepresentation.volumeInfo.imageLinks?.thumbnail,
            let averageRating = bookRepresentation.volumeInfo.averageRating,
            let publishedDate = bookRepresentation.volumeInfo.publishedDate,
            let hasRead = bookRepresentation.hasRead,
            let review = bookRepresentation.review
            else {return nil}
        
        self.init(title: title, hasRead: hasRead, id: id, thumbnail: thumbnail, review: review, averageRating: averageRating, author: author, publishedDate: publishedDate, context: context)
    }
    
}
