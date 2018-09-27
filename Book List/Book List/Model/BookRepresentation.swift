//
//  BookRepresentation.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation

/// Representation for handling a JSON book object
class BookRepresentation: Codable, Equatable {
    let volumeInfo: VolumeInfo
    let id: String
    var thumbnailData: Data?
    var imageData: Data?
    
    static func == (lhs: BookRepresentation, rhs: BookRepresentation) -> Bool {
        return lhs.id == rhs.id
    }
}

/// Represents the top level JSON object
struct BooksResults: Codable, Equatable {
    let items: [BookRepresentation]?
}

// Other objects for handling JSON
struct VolumeInfo: Codable, Equatable {
    let title: String
    let authors: [String]?
    let imageLinks: ImageLinks?
    let description: String?
    let pageCount: Int16?
}

struct ImageLinks: Codable, Equatable {
    let thumbnail: String
    let small: String?
    let medium: String?
    let large: String?
    let extraLarge: String?
    
    var biggestImage: String {
        return extraLarge ?? large ?? medium ?? small ?? thumbnail
    }
    
}

// MARK: - Equatable Methods
func == (lhs: BookRepresentation, rhs: Book) -> Bool {
    return lhs.id == rhs.id && lhs.volumeInfo.title == rhs.title && lhs.volumeInfo.imageLinks?.thumbnail == rhs.thumbnailURL && lhs.volumeInfo.imageLinks?.biggestImage == rhs.imageURL && lhs.volumeInfo.pageCount == rhs.pageCount
}

func == (lhs: Book, rhs: BookRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: BookRepresentation, rhs: Book) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: Book, rhs: BookRepresentation) -> Bool {
    return rhs != lhs
}
