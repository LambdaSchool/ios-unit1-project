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

func == (lhs: VolumeRepresentation, rhs: Volume) -> Bool {
    return
        lhs.id == rhs.id &&
            lhs.volumeInfo.title == rhs.title &&
            lhs.volumeInfo.subtitle == rhs.subtitle &&
            lhs.volumeInfo.authors.joined(separator: ", ") == rhs.authors &&
            lhs.volumeInfo.imageLinks.thumbnail == rhs.image
    
}

func == (lhs: Volume, rhs: VolumeRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: VolumeRepresentation, rhs: Volume) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: Volume, rhs: VolumeRepresentation) -> Bool {
    return rhs != lhs
}
