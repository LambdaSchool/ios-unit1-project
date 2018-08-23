//
//  BookRepresentation.swift
//  Books
//
//  Created by Andrew Liao on 8/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import Foundation

struct Bookshelf: Codable, Equatable {
    let totalItems: Int?
    let items: [BookRepresentation]?
}

struct BookRepresentation: Codable, Equatable {
//    let title: String
//    let author: String

//    var imageLinks: String
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable, Equatable {
    let title: String
    let authors: [String]?
    let imageLinks: [String: String]?
}
