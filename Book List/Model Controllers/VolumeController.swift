//
//  VolumeController.swift
//  Book List
//
//  Created by Moin Uddin on 9/24/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation
import CoreData

class VolumeController {
    
    
    func createVolume(title: String, id: String, imageLink: String) {
        let volume = Volume(title: title, id: id, imageLink: imageLink)
        saveToPersistent()
        //put(volume: volume)
    }
    
    func toggleHasRead(volume: Volume) {
        //No Network Request Needed, Only Core Data
        volume.hasRead = !volume.hasRead
        //If the book has Been Read move it to has read bookshelf
        // Else move to or keep at to read bookshelf
        saveToPersistent()
    }
    
    func updateVolume(volume: Volume, hasRead: Bool, review: String) {
        volume.hasRead = hasRead
        volume.review = review
        saveToPersistent()
    }
    
    
    
    func saveToPersistent() {
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error Saving to Core Data: \(error)")
        }
    }
    
    
    //Network Requests
    
    func searchForVolumes(searchTerm: String, completion: @escaping (Error?) -> Void) {
        let searchUrl = baseUrl.appendingPathComponent("volumes")
        var components = URLComponents(url: searchUrl, resolvingAgainstBaseURL: true)
        
        let queryParameters = ["q": searchTerm]
        
        components?.queryItems = queryParameters.map{URLQueryItem(name: $0.key, value: $0.value)}
        
        guard let requestURL = components?.url else {
            completion(NSError())
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) {(data, _, error) in
            if let error = error {
                NSLog("Error searching for volume: \(error)")
                completion(error)
            }
            
            guard let data = data else {
                NSLog("No data was returned")
                completion(NSError())
                return
            }
            
            do {
                let volumeRepresentations =  try JSONDecoder().decode(VolumeRepresentations.self, from: data).items
                self.searchedVolumes = volumeRepresentations
                
                completion(nil)
            } catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(error)
            }

        }.resume()
    }
    
    var baseUrl = URL(string: "https://www.googleapis.com/books/v1/")!
    var dummyUrl = "https://www.googleapis.com/books/v1/users/114839501015697372432/bookshelves/0/volumes"
    var searchedVolumes: [VolumeRepresentation] = []
}
