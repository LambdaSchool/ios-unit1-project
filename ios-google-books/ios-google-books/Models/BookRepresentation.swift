//
//  BookRepresentation.swift
//  ios-google-books
//
//  Created by Conner on 8/22/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation

struct BookRepresentation: Decodable {
  let id: String
  let volumeInfo: Info
  
  struct Info: Decodable {
    let title: String
    let authors: [String]?
    let publishedDate: String?
    let description: String?
    let pageCount: Int?
    let averageRating: Double?
    let imageLinks: ImageLinks?
    
    struct ImageLinks: Decodable {
      let smallThumbnail: String?
      let thumbnail: String?
    }
  }
}

struct BookRepresentationItems: Decodable {
  var items: [BookRepresentation]
}
