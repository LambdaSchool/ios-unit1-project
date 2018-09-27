//
//  BookshelfRepresentation.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation

/// Representation for handling a JSON bookshelf object
struct BookshelfRepresentation: Codable {
    let title: String
    let id: Int16
    let volumeCount: Int
}

/// Represents the top level JSON object
struct BookshelvesRepresentationResults: Codable {
    let items: [BookshelfRepresentation]
}
