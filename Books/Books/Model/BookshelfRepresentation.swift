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

func == (lhs: BookshelfRepresentation, rhs: Bookshelf) -> Bool {
    return
        lhs.title == rhs.title &&
            lhs.id == rhs.id
}

func == (lhs: Bookshelf, rhs: BookshelfRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: BookshelfRepresentation, rhs: Bookshelf) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: Bookshelf, rhs: BookshelfRepresentation) -> Bool {
    return rhs != lhs
}
