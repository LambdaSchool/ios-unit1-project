//
//  BookRepresentation.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation

struct BookRepresentation: Codable {
    let volumeInfo: VolumeInfo
    let id: String
    let thumbnailData: Data?
    let imageData: Data?
}

struct BooksResults: Codable {
    let items: [BookRepresentation]?
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let imageLinks: ImageLinks?
    let description: String?
    let pageCount: Int16?
}

struct ImageLinks: Codable {
    let thumbnail: String
    let small: String?
    let medium: String?
    let large: String?
    let extraLarge: String?
    
    var biggestImage: String {
        return extraLarge ?? large ?? medium ?? small ?? thumbnail
    }
    
}
