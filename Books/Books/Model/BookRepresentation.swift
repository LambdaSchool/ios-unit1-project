//
//  Book.swift
//  Books
//
//  Created by Farhan on 9/24/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation

struct BookRepresentation: Equatable, Codable{
    
    let id: String?
    let hasRead: Bool?
    let review: String?
    
    struct VolumeInfo: Equatable, Codable{
        
        let title: String?
        let publishedDate: String?
        let authors: [String]?
        let averageRating: Double?
        struct ImageLinks: Equatable, Codable{
            let thumbnail: String?
        }
        
        let imageLinks: ImageLinks?
    }
    
    let volumeInfo: VolumeInfo
    
}

struct SearchResults: Codable{
    var items: [BookRepresentation]
}
