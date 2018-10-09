//
//  Volume+Encodable.swift
//  Book List
//
//  Created by Moin Uddin on 9/25/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation


extension Volume: Encodable {
    enum CodingKeys: String, CodingKey {
        case title
        case id
        case review
        case hasRead
        case imageLink
    }
    public func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.review, forKey: .review)
        try container.encode(self.hasRead, forKey: .hasRead)
        try container.encode(self.imageLink, forKey: .imageLink)
    }
}
