//
//  VolumeController.swift
//  Books
//
//  Created by Daniela Parra on 9/25/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class VolumeController {
    
    // MARK: - CRUD Methods
    
    //Create volume from volume representation.
    func createVolume(from volumeRepresentation: VolumeRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        Volume(volumeRepresentation: volumeRepresentation, context: context)
        
        //save to Persistent Store should I do this in perform block?
        do {
            try context.save()
        } catch {
            NSLog("Error saving newly created volume: \(error)")
        }
        
        //PUT volume
    }
    
    //Update book.
    func updateVolume(volume: Volume, myReview: String, myRating: Int, hasRead: Bool) {
        volume.myReview = myReview
        volume.myRating = Int16(myRating)
        volume.hasRead = hasRead
        
        
        //Save to PS?
        //PUT volume
    }
    
    //Delete book.
    func delete(volume: Volume) {
        let moc = CoreDataStack.shared.mainContext
        
        //delete volume from server
        
        moc.delete(volume)
        
        do {
            try CoreDataStack.shared.save(context: moc)
        } catch {
            moc.reset()
            NSLog("Error saving moc after deleting volume: \(error)")
        }
    }
    
    
    // MARK: - API Search Query
    
    //Search books
    func searchBooks(searchTerm: String, completion: @escaping (Error?) -> Void) {
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let queryParameters = ["q": searchTerm]
        
        components?.queryItems = queryParameters.map({URLQueryItem(name: $0.key, value: $0.value)})
        
        guard let requestURL = components?.url else {
            completion(NSError())
            return
        }
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error searching for books with search term \(searchTerm): \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            do {
                let searchResults = try JSONDecoder().decode(VolumeSearchResults.self, from: data)
                self.volumes = searchResults.items
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
        
    }
    
    func displayImage(volume: Volume, imageView: UIImageView) {
        let url = URL(string: volume.image!)
        
        do {
            let data = try Data(contentsOf: url!)
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        } catch {
            NSLog("Error creating image data from url: \(error)")
        }
    }
    
    // MARK: - Properties
    
    var volumes: [VolumeRepresentation] = []
    var bookshelfController: BookshelfController?
    lazy var fetchController = ""
    
    private let baseURL = URL(string: "https://www.googleapis.com/books/v1/volumes")!
}
