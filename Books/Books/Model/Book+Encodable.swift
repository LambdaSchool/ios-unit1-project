//
//  Book+Encodable.swift
//  Books
//
//  Created by Farhan on 9/25/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation

extension Book: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case hasRead
        case id
        case review
        case thumbnail
        case publishedDate
        case author
        case averageRating
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.title, forKey: .title)
        try container.encode(self.hasRead, forKey: .hasRead)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.review, forKey: .review)
        try container.encode(self.thumbnail, forKey: .thumbnail)
        try container.encode(self.author, forKey: .author)
        try container.encode(self.averageRating, forKey: .averageRating)
        try container.encode(self.publishedDate, forKey: .publishedDate)
        
    }
}
