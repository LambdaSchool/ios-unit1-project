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
    
    var title: String
    var abstract: String
    var image: Data
    var hasRead: Bool
    var pages: String
    var price: String
    var timestamp: Date
    
}
