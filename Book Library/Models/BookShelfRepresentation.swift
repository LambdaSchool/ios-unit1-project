//
//  BookShelfRepresentation.swift
//  Book Library
//
//  Created by Jeremy Taylor on 8/22/18.
//  Copyright © 2018 Bytes-Random L.L.C. All rights reserved.
//

import Foundation

struct BookshelfRepresentation: Codable {
    let items: [Items]
    struct Items: Codable {
        let id: Int
        let title: String
    }
    
}

struct BookshelfRepresentations: Codable {
    let items: [BookshelfRepresentation]
}
