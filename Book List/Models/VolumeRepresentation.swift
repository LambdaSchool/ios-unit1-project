//
//  VolumeRepresentation.swift
//  Book List
//
//  Created by Moin Uddin on 9/24/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation


func == (lhs: VolumeRepresentation, rhs: Volume) -> Bool {
    // Come back and add all equtable scenarios
    return lhs.volumeInfo.title == rhs.title 
}

func == (lhs: Volume, rhs: VolumeRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: Volume, rhs: VolumeRepresentation) -> Bool {
    return rhs != lhs
}

func != (lhs: VolumeRepresentation, rhs: Volume) -> Bool {
    return !(rhs == lhs)
}


struct VolumeRepresentation: Equatable, Codable {
    let id: String
    let volumeInfo: VolumeInfo

    let hasRead: Bool?
    let review: String?
    
    struct VolumeInfo: Codable, Equatable {
        let title: String
        let imageLinks: ImageLinks?
        struct ImageLinks: Codable, Equatable {
            let thumbnail: String
            let smallThumbnail: String
        }
    }
    
}


struct VolumeRepresentations: Codable {
    let items: [VolumeRepresentation]
}
