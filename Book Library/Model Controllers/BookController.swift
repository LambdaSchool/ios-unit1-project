//
//  BookController.swift
//  Book Library
//
//  Created by Jeremy Taylor on 8/21/18.
//  Copyright © 2018 Bytes-Random L.L.C. All rights reserved.
//

import Foundation

class BookController {
    
    private let baseURL = URL(string: "https://www.googleapis.com/books/v1/")!
    
    func searchForBook (with searchTerm: String, completion: @escaping (Error?) -> Void) {
        var components = URLComponents(url: baseURL.appendingPathComponent("volumes"), resolvingAgainstBaseURL: true)
        let queryParameters = ["q": searchTerm]
        components?.queryItems = queryParameters.map({URLQueryItem(name: $0.key, value: $0.value)})
        let url = components?.url!
        let request = URLRequest(url: url!)
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            
            if let error = error {
                NSLog("Error adding authorization to request: \(error)")
                return
            }
            guard let request = request else { return }
            
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    NSLog("Error getting volumes: \(error)")
                    return
                }
                guard let data = data else { return }
                
                if let json = String(data: data, encoding: .utf8) {
                    print(json)
                }
                
                do {
                    let bookRepresentations = try JSONDecoder().decode(SearchVolumeRepresentations.self, from: data).items
                    self.searchedVolumes = bookRepresentations
                    completion(nil)
                } catch {
                    NSLog("Error decoding JSON data: \(error)")
                    completion(error)
                }
            }.resume()
        }
        
    }
    
    func getBookshelves(completion: @escaping (Error?) -> Void) {
        let components = URLComponents(url: baseURL.appendingPathComponent("mylibrary").appendingPathComponent("bookshelves"), resolvingAgainstBaseURL: true)
        let url = components?.url!
        let request = URLRequest(url: url!)
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            
            if let error = error {
                NSLog("Error adding authorization to request: \(error)")
                return
            }
            guard let request = request else { return }
            
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    NSLog("Error getting bookshelves: \(error)")
                    return
                }
                guard let data = data else { return }
                
//                if let json = String(data: data, encoding: .utf8) {
//                    print(json)
//                }
                
                do {
                    let bookshelfRepresentations = try JSONDecoder().decode(BookshelfRepresentations.self, from: data).items
                    self.bookshelves = bookshelfRepresentations
                    //print(self.bookshelves)
                    completion(nil)
                } catch {
                    NSLog("Error decoding JSON data: \(error)")
                    completion(error)
                }
            }.resume()
        }
        
    }
    func getVolumes(forBookshelf shelf: Int, completion: @escaping (Error?) -> Void) {
        let components = URLComponents(url: baseURL.appendingPathComponent("mylibrary").appendingPathComponent("bookshelves").appendingPathComponent("\(shelf)").appendingPathComponent("volumes"), resolvingAgainstBaseURL: true)
        let url = components?.url!
        let request = URLRequest(url: url!)
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            
            if let error = error {
                NSLog("Error adding authorization to request: \(error)")
                return
            }
            guard let request = request else { return }
            
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    NSLog("Error getting bookshelf volumes: \(error)")
                    return
                }
                guard let data = data else { return }
                
                if let json = String(data: data, encoding: .utf8) {
                    print(json)
                }
                
                do {
                    let volumeRepresentations = try JSONDecoder().decode(VolumeRepresentations.self, from: data).items
                    self.bookshelfVolumes = volumeRepresentations
                    completion(nil)
                } catch {
                    NSLog("Error decoding JSON data: \(error)")
                    completion(error)
                }
            }.resume()
        }
    }
    
    var searchedVolumes: [SearchVolumeRepresentation] = []
    var bookshelves: [BookshelfRepresentation] = []
    var bookshelfVolumes: [VolumeRepresentation] = []
    
} 
