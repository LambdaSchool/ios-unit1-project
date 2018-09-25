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
        saveToPersistent()
    }
    
    func updateVolume(volume: Volume, title: String, hasRead: Bool, review: String) {
        volume.title = title
        volume.hasRead = hasRead
        volume.review = review
    }
    
    
    
    func saveToPersistent() {
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error Saving to Core Data: \(error)")
        }
    }
    
    
    var dummyUrl = "https://www.googleapis.com/books/v1/users/114839501015697372432/bookshelves/0/volumes"
}
