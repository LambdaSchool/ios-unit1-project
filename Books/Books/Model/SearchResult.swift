//
//  SearchResults.swift
//  Books
//
//  Created by Linh Bouniol on 8/20/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation

struct SearchResult: Decodable, Equatable {
    var title: String
    var image: String?
    var identifier: String
    var authors: [String]?
    
    struct VolumeInfo: Decodable {
        var title: String
        var authors: [String]?
//        var description: String?
        var imageLinks: [String : String]?
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case volumeInfo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(String.self, forKey: .id)
        let volumeInfo = try container.decode(VolumeInfo.self, forKey: .volumeInfo)
        
        self.title = volumeInfo.title
        // Url for image
        if let imageLink = volumeInfo.imageLinks?["thumbnail"] {
            self.image = imageLink.replacingOccurrences(of: "http://", with: "https://")
        }
        
        self.identifier = id
        self.authors = volumeInfo.authors
    }
}

struct SearchResults: Decodable {
    let items: [SearchResult]
}
