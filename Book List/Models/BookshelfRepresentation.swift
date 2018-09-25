//
//  BookshelfRepresentation.swift
//  Book List
//
//  Created by Moin Uddin on 9/25/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation


func == (lhs: BookshelfRepresentation, rhs: Bookshelf) -> Bool {
    return lhs.title == rhs.title && lhs.id == rhs.id
}

func == (lhs: Bookshelf, rhs: BookshelfRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: Bookshelf, rhs: BookshelfRepresentation) -> Bool {
    return rhs != lhs
}

func != (lhs: BookshelfRepresentation, rhs: Bookshelf) -> Bool {
    return !(rhs == lhs)
}

struct BookshelfRepresentation: Codable {
    let title: String
    let id: Int16
}


struct BookshelfRepresentations: Codable {
    let items: [BookshelfRepresentation]
}
