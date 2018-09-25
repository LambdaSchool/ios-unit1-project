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
        let averageRating: Double
        let imagelinks: ImageLinks
        
        struct ImageLinks: Codable {
            let smallThumbnail: String
            let thumbnail: String
            let small: String
        }
    }
}

struct VolumeSearchResults {
    let items: [VolumeRepresentation]
}

