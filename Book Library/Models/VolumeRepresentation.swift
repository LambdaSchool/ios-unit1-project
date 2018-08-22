//
//  VolumeRepresentation.swift
//  Book Library
//
//  Created by Jeremy Taylor on 8/21/18.
//  Copyright © 2018 Bytes-Random L.L.C. All rights reserved.
//

import Foundation

struct VolumeRepresentation: Codable {
    let volumeInfo: VolumeInfo
    struct VolumeInfo: Codable {
        let title: String
        let authors: [String]
        let imageLinks: ImageLinks
    }
    struct ImageLinks: Codable {
        let thumbnail: URL
    }
}

struct VolumeRepresentations: Codable {
    let items: [VolumeRepresentation]
}




