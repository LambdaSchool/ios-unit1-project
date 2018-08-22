//
//  BookRepresentation.swift
//  Books
//
//  Created by Andrew Liao on 8/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import Foundation

struct BookRepresentation: Codable, Equatable {
    let title: String
    var isRead: Bool
    var review: String
    var imagePath: String
    var identifier: UUID
}
