//
//  Book+Encodable.swift
//  books-list
//
//  Created by De MicheliStefano on 21.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

extension Book: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case abstract
        case image
        case hasRead
        case pages
        case price
        case timestamp
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(abstract, forKey: .abstract)
        try container.encode(image, forKey: .image)
        try container.encode(hasRead, forKey: .hasRead)
        try container.encode(pages, forKey: .pages)
        try container.encode(price, forKey: .price)
        try container.encode(timestamp, forKey: .timestamp)
    }
    
}
