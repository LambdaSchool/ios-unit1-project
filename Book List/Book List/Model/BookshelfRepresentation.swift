//
//  BookshelfRepresentation.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation

struct BookshelfRepresentation: Codable {
    let title: String
    let id: Int16
}

struct BookshelvesRepresentationResults: Codable {
    let items: [BookshelfRepresentation]
}
