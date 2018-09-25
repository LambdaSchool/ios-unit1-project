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
    
    
    func createVolume(title: String, id: String, imageLink: String, review: String = "", hasRead: Bool = false) {
        let volume = Volume(title: title, id: id, hasRead: hasRead, review: review, imageLink: imageLink)
        addVolume(volume: volume)
        //saveToPersistent()
        //put(volume: volume)
    }
    
    
    func updateVolume(volume: Volume, hasRead: Bool, review: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        volume.hasRead = hasRead
        volume.review = review
        saveToPersistent(context: context)
        //Persist on database side
        //put(volume: volume)
    }
    
    func deleteVolume(volume: Volume, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let moc = CoreDataStack.shared.mainContext
        deleteVolumeFromServer(volume: volume)
        moc.delete(volume)
        saveToPersistent(context: context)
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
    
    
    
    func saveToPersistent(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error Saving to Core Data: \(error)")
        }
    }
    
    
    //Network Requests
    
    func searchForVolumes(searchTerm: String, completion: @escaping CompletionHandler) {
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
    
    func addVolume(volume: Volume, completion: @escaping CompletionHandler = { _ in }) {
        //Adds to favorites. Just Testing to make sure PUT Works
        //Will Refactor and Modularize to be dynamic for any bookshelf
        guard let id = volume.id else { return }
        let addVolumeUrl = baseUrl.appendingPathComponent("mylibrary").appendingPathComponent("bookshelves").appendingPathComponent("0").appendingPathComponent("addVolume")
        let queryParameters = ["volumeId": id]
        var components = URLComponents(url: addVolumeUrl, resolvingAgainstBaseURL: true)
        components?.queryItems = queryParameters.map{URLQueryItem(name: $0.key, value: $0.value)}
        
        guard let requestURL = components?.url else {
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONEncoder().encode(volume)
            completion(nil)
        } catch {
            NSLog("Error encoding JSON data: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) {(data, _, error) in
            if let error = error {
                NSLog("Error adding volume: \(error)")
                completion(error)
            }
            completion(nil)
            }.resume()
    }
    
    func deleteVolumeFromServer(volume: Volume) {
        
    }
    
    
    
    
    typealias CompletionHandler = (Error?) -> Void
    var baseUrl = URL(string: "https://www.googleapis.com/books/v1/")!
    var bookShelvesUrl = URL(string: "https://www.googleapis.com/books/v1/mylibrary/bookshelves/")!
    var dummyUrl = "https://www.googleapis.com/books/v1/users/114839501015697372432/bookshelves/0/volumes"
    var searchedVolumes: [VolumeRepresentation] = []
}
