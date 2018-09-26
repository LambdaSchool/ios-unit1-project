//
//  VolumeRepresentation.swift
//  Books
//
//  Created by Daniela Parra on 9/25/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

struct VolumeRepresentation: Codable {
    
    let id: String
    let volumeInfo: VolumeInfo
    
    struct VolumeInfo: Codable {
        let title: String
        let subtitle: String?
        let authors: [String]
        let averageRating: Double?
        let imageLinks: ImageLinks
        
        struct ImageLinks: Codable {
            let thumbnail: String
        }
    }
}

struct VolumeSearchResults: Codable {
    let items: [VolumeRepresentation]
}

