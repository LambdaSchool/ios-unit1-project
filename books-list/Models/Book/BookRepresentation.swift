//
//  BookRepresentation.swift
//  books-list
//
//  Created by De MicheliStefano on 21.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

struct BookRepresentation: Decodable, Equatable {
    
    let id: String
    let volumeInfo: VolumeInfo
    
    struct VolumeInfo: Codable, Equatable {
        let title: String
        let abstract: String?
        let authors: [String]?
        let pageCount: Int?
        let averageRating: Double?
        let ratingsCount: Int?
        let industryIdentifiers: [ISBN]
        let imageLinks: ImageLinks
        
        enum CodingKeys: String, CodingKey {
            case title
            case abstract = "description"
            case authors
            case pageCount
            case averageRating
            case ratingsCount
            case industryIdentifiers
            case imageLinks
        }
        
        struct ISBN: Codable, Equatable {
            let type: String
            let identifier: String
        }
        
        struct ImageLinks: Codable, Equatable {
            let smallThumbnail: URL
        }
    }
    
}

struct BookRepresentations: Decodable {
    let items: [BookRepresentation]?
}

// TODO: == funcs
