//
//  CollectionRepresentation.swift
//  books-list
//
//  Created by De MicheliStefano on 22.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import CoreData

struct CollectionRepresentation: Decodable, Equatable {
    
    let title: String
    let identifier: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case identifier = "id"
    }
    
}

struct CollectionRepresentations: Decodable {
    let items: [CollectionRepresentation]
}

func ==(lhs: Collection, rhs: CollectionRepresentation) -> Bool {
    return lhs.title == rhs.title &&
            lhs.identifier == String(rhs.identifier)
}

func ==(lhs: CollectionRepresentation, rhs: Collection) -> Bool {
    return rhs == lhs
}

func !=(lhs: Collection, rhs: CollectionRepresentation) -> Bool {
    return !(rhs == lhs)
}

func !=(lhs: CollectionRepresentation, rhs: Collection) -> Bool {
    return rhs != lhs
}
