//
//  BookController.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation

class BookController {
    func fetchImageFor(book: Book, completion: @escaping CompletionHandler = { _ in }) {
        guard let urlString = book.thumbnailURL, let url = URL(string: urlString), book.thumbnailData == nil else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching image data: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            let backgroundContext = CoreDataStack.shared.container.newBackgroundContext()
            
            backgroundContext.performAndWait {
                book.thumbnailData = data
            }
            
            do {
                try CoreDataStack.shared.save(context: backgroundContext)
            } catch {
                NSLog("Error saving background context: \(error)")
            }
        }.resume()
    }
}
