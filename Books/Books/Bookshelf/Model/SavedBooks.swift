//
//  SavedBooks.swift
//  Books
//
//  Created by Sergey Osipyan on 1/7/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import Foundation

class SavedBooks {
    
    
    static let shared = SavedBooks()
    private init() {}
    
    var savedBook: SavedBooksJson?
    var savedBooks: [SavedBooksJson] = []
    
    func addNewSavedBook() {
        guard let savedBook = savedBook else {return}
        savedBooks.append(savedBook)
    }
    
    func numberOfSavedBook() -> Int {
        return savedBooks.count
    }
    
    func savedBook(at index: Int) -> SavedBooksJson {
        return savedBooks[index]
    }
    
    func deleteSavedBook(at indexPath: IndexPath) {
        savedBooks.remove(at: indexPath.row)
        
    }
    
    struct SavedBooksJson: Codable {
        let volumeInfo: VolumeInfo
        
        struct VolumeInfo: Codable {
            let title: String?
            let subtitle: String?
            let authors: [String]?
            let imageLinks: ImageLink?
            let description: String?
            let infoLink: String?
            let pageCount: Int?
            
            struct ImageLink: Codable {
                let smallThumbnail: String?
                let thumbnail: String?
            }
        }
    }
}



