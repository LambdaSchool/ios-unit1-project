//
//  BookshelfRepresentation.swift
//  Books
//
//  Created by Daniela Parra on 9/26/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

struct BookshelfRepresentation: Codable {
    let title: String
    let id: Int
}

struct BookshelfResults: Codable {
    let items: [BookshelfRepresentation]
}
