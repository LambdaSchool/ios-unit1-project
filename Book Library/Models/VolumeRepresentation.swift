//
//  VolumeRepresentation.swift
//  Book Library
//
//  Created by Jeremy Taylor on 8/23/18.
//  Copyright © 2018 Bytes-Random L.L.C. All rights reserved.
//

import Foundation

struct VolumeRepresentation: Codable {
    let id: String
    let volumeInfo: VolumeInfo
    struct VolumeInfo: Codable {
        let title: String
        let subtitle: String?
        let authors: [String]?
        let description: String
    }
}

struct VolumeRepresentations: Codable {
    let items: [VolumeRepresentation]
}
