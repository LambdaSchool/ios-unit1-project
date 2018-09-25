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
}

struct BooksResults: Codable {
    let items: [BookRepresentation]
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]
    let imageLinks: ImageLinks
}

struct ImageLinks: Codable {
    let smallThumbnail: String
    let thumbnail: String
    let small: String?
    let medium: String?
    let large: String?
    let extraLarge: String?
    
    var biggestImage: String {
        return extraLarge ?? large ?? medium ?? small ?? thumbnail
    }
    
}
