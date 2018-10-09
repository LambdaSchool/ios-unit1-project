//
//  BookshelfController.swift
//  Book List
//
//  Created by Moin Uddin on 9/25/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation
import CoreData

class BookshelfController {
    
    init() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Bookshelf")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)

        do {
                 let result = try CoreDataStack.shared.mainContext.execute(request)
        }
        catch {
            NSLog("\(error)")
        }
        fetchBookShelvesFromServer()
    }
    
    func deleteVolumeFromBookshelf(volume: Volume, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let moc = CoreDataStack.shared.mainContext
        //Insert deleteFromServer function
        moc.delete(volume)
        saveToPersistent()
    }
    
    func createBookshelf(title: String, id: Int16, volumeCount: Int16, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let _ = Bookshelf(title: title, id: id)
        //Can't create bookshelf in server
        saveToPersistent()
    }
    
    func update(bookshelf: Bookshelf, bookshelfRepresentation: BookshelfRepresentation) {
            bookshelf.title = bookshelfRepresentation.title
            bookshelf.id = bookshelfRepresentation.id
            //bookshelf.volumeCount = bookshelfRepresentation.volumeCount
    }
    
    func updateVolumeInBookshelf(volume: Volume, hasRead: Bool?, review: String?) {
        if let hasRead = hasRead {
            volume.hasRead = hasRead
        }
        if let review = review {
            volume.review = review
        }
        saveToPersistent()
    }
    
    func updateVolume(volume: Volume, volumeRepresentation: VolumeRepresentation) {
        volume.id = volumeRepresentation.id
        volume.title = volumeRepresentation.volumeInfo.title
        volume.imageLink = volumeRepresentation.volumeInfo.imageLinks?.thumbnail
    }
    
    func saveToPersistent(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error Saving to Core Data: \(error)")
        }
    }
    
    func fetchSingleBookshelfFromPersistentStore(id: String, context: NSManagedObjectContext) -> Bookshelf? {
        let fetchRequest: NSFetchRequest<Bookshelf> = Bookshelf.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        
        var bookshelf: Bookshelf? = nil
        
        do {
            bookshelf = try context.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching bookshelf with id \(id): \(error)")
        }
        
        return bookshelf
    }
    
    
    func fetchSingleVolumeFromPersistentStore(id: String, context: NSManagedObjectContext) -> Volume? {
        let fetchRequest: NSFetchRequest<Volume> = Volume.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate

        var volume: Volume? = nil

        do {
            volume = try context.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching volume with id \(id): \(error)")
        }

        return volume
    }
    
    func fetchVolumesFromShelf(bookshelf: Bookshelf, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseUrl.appendingPathComponent("mylibrary").appendingPathComponent("bookshelves").appendingPathComponent(String(bookshelf.id)).appendingPathComponent("volumes")
        let request = URLRequest(url: requestURL)
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            if let error = error {
                NSLog("Error adding authorization to request: \(error)")
                completion(error)
                return
            }
            
            guard let request = request else { return }
            URLSession.shared.dataTask(with: request) {(data, _, error) in
                if let error = error {
                    NSLog("Error getting all volumes in bookshelf: \(error)")
                    completion(error)
                }
                
                guard let data = data else {
                    NSLog("No data was returned")
                    completion(NSError())
                    return
                }
                var volumeRepresentations: [VolumeRepresentation] = []
                
                do {
                    let volumeRepresentations =  try JSONDecoder().decode(VolumeRepresentations.self, from: data).items
                    let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                    for volumeRep in volumeRepresentations {
                        if let volume = self.fetchSingleVolumeFromPersistentStore(id: String(volumeRep.id), context: CoreDataStack.shared.mainContext) {

                            guard let bookshelfVolumes = bookshelf.volumes else { return }
                            //Check to see if Bookshelf contains this volume
                            if bookshelfVolumes.contains(volume) {
                                print("Update volume in bookshelf")
                                self.updateVolume(volume: volume, volumeRepresentation: volumeRep)
                            } else {
                                //If not add it
                                print("Create volume in bookshelf")
                                bookshelf.addToVolumes(volume)
                            }
                        } else {
                            // If not create it using Volume Represenations and add it to the bookshelf
                            print("Creates Volume in Bookshelf from scratch")
                            bookshelf.addToVolumes(Volume(title: volumeRep.volumeInfo.title, id: volumeRep.id, imageLink: (volumeRep.volumeInfo.imageLinks?.thumbnail) ?? "http://support.yumpu.com/en/wp-content/themes/qaengine/img/default-thumbnail.jpg"))
                        }
                    }
                    self.saveToPersistent(context: backgroundContext)
                    completion(nil)
                    
                } catch {
                    NSLog("Error decoding JSON data: \(error)")
                    completion(error)
                }
                
                }.resume()
        }
    }
    
    func deleteVolumeFromBookShelfInServer(volume: Volume) {
        
    }
    
    
    func fetchBookShelvesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseUrl.appendingPathComponent("mylibrary").appendingPathComponent("bookshelves")
        let request = URLRequest(url: requestURL)
        
        GoogleBooksAuthorizationClient.shared.addAuthorization(to: request) { (request, error) in
            if let error = error {
                NSLog("Error adding authorization to request: \(error)")
                completion(error)
                return
            }
            
            guard let request = request else { return }
            URLSession.shared.dataTask(with: request) {(data, _, error) in
            if let error = error {
                NSLog("Error getting all Bookshelves: \(error)")
                completion(error)
            }
            
            guard let data = data else {
                NSLog("No data was returned")
                completion(NSError())
                return
            }
            
            do {
                let bookshelfRepresentations =  try JSONDecoder().decode(BookshelfRepresentations.self, from: data).items
                let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
                
                
                backgroundContext.performAndWait {
                    for bookshelfRep in bookshelfRepresentations {
                        if let bookshelf = self.fetchSingleBookshelfFromPersistentStore(id: String(bookshelfRep.id), context: backgroundContext) {
                            if bookshelf != bookshelfRep {
                                print("goes to update bookshelf in core data")
                                self.update(bookshelf: bookshelf, bookshelfRepresentation: bookshelfRep)
                            }
                        } else {
                            print("goes to create bookshelf in core data")
                            _ = Bookshelf(bookshelfRepresentation: bookshelfRep, context: backgroundContext)
                        }
                    }
                }
                
                self.saveToPersistent(context: backgroundContext)
                completion(nil)
                
            } catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(error)
            }
            
            }.resume()
        }
    }
    
    typealias CompletionHandler = (Error?) -> Void
    var baseUrl = URL(string: "https://www.googleapis.com/books/v1/")!
    
}
