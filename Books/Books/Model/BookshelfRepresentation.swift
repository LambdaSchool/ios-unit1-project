//
//  BookshelfRepresentation.swift
//  Books
//
//  Created by Linh Bouniol on 8/22/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation

struct BookshelfRepresentation: Decodable, Equatable {
    var id: Int
    var title: String
}

struct BookshelvesRepresentation: Decodable {
    let items: [BookshelfRepresentation]
}

func ==(lhs: BookshelfRepresentation, rhs: Bookshelf) -> Bool {
    return lhs.title == rhs.name && lhs.id as NSNumber == rhs.identifier
}

func ==(lhs: Bookshelf, rhs: BookshelfRepresentation) -> Bool {
    return rhs == lhs
}

func !=(lhs: BookshelfRepresentation, rhs: Bookshelf) -> Bool {
    return !(rhs == lhs)
}

func !=(lhs: Bookshelf, rhs: BookshelfRepresentation) -> Bool {
    return rhs != lhs
}
